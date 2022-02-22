//
//  PictureIngredientViewController.swift
//  Reciptopia_iOS
//
//  Created by 김세영 on 2022/02/21.
//

import UIKit
import Combine
import ReciptopiaKit
import Reciptopia_UIKit
import BSImagePicker
import Photos

public class PictureIngredientViewController: NiblessViewController {
  
  // MARK: - Dependencies
  let viewModel: PictureIngredientViewModel
  let makeManagePictureViewController: () -> ManagePictureViewController
  
  // MARK: - Properties
  private var bag = Set<AnyCancellable>()
  
  lazy var searchByNameButton: UIButton = {
    let button = UIButton()
    button.setTitle("이름으로 검색", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.setTitleFont(.boldSystemFont(ofSize: 14))
    button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
    button.tintColor = .black
    button.contentEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 10)
    return button
  }()
  
  lazy var notificationButton: UIBarButtonItem = {
    let button = UIBarButtonItem(
      image: UIImage(systemName: "bell.fill"),
      style: .plain,
      target: viewModel,
      action: #selector(PictureIngredientViewModel.presentNotification)
    )
    button.tintColor = .black
    return button
  }()
  
  // MARK: - Methods
  public init(viewModel: PictureIngredientViewModel,
              managePictureViewControllerFactory: @escaping () -> ManagePictureViewController) {
    self.viewModel = viewModel
    self.makeManagePictureViewController = managePictureViewControllerFactory
    super.init()
    observeViewModel()
  }
  
  private func observeViewModel() {
    viewModel.action.sink { [weak self] action in
      guard let strongSelf = self else { return }
      switch action {
        case .photoAlbum: strongSelf.presentPhotoAlbum()
        case .managePicture: strongSelf.presentManagePicture()
        case .checkIngredients(let ingredients): print("present check \(ingredients).")
        case .community: print("present commnity.")
        case .search: print("present search.")
        case .notification: print("present notification.")
      }
    }.store(in: &bag)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    view = PictureIngredientRootView(viewModel: viewModel)
    configureNavigationBar()
  }
  
  private func configureNavigationBar() {
    navigationItem.titleView = searchByNameButton
    navigationItem.setRightBarButton(notificationButton, animated: false)
    addBarButtonTargets()
  }
  
  private func addBarButtonTargets() {
    searchByNameButton.addTarget(
      viewModel,
      action: #selector(PictureIngredientViewModel.presentSearch),
      for: .touchUpInside
    )
  }
  
  private func presentManagePicture() {
    let managePictureViewController = makeManagePictureViewController()
    navigationItem.backButtonTitle = ""
    navigationController?.pushViewController(managePictureViewController, animated: true)
  }
  
  private func presentPhotoAlbum() {
    let picker = ImagePickerController()
    picker.settings.selection.max = viewModel.remainingPictureCount
    
    presentImagePicker(picker, select: nil, deselect: nil, cancel: nil, finish: { assets in
      self.appendImageByAsset(assets)
    })
  }
  
  private func appendImageByAsset(_ assets: [PHAsset]) {
    let manager = PHImageManager.default()
    let option = PHImageRequestOptions()
    option.deliveryMode = .opportunistic
    option.resizeMode = .exact
    option.isSynchronous = true
    
    assets.forEach { asset in
      DispatchQueue.global(qos: .background).async {
        let size = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        manager.requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: option) {
          [weak self] image, _ in
          guard let imageData = image?.jpegData(compressionQuality: 1) else { return }
          self?.viewModel.addPicture(imageData)
        }
      }
    }
  }
}
