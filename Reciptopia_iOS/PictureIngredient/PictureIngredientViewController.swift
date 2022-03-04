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
  let makeSearchIngredientViewController: () -> SearchIngredientViewController
  let makeCheckIngredientViewController: ([Ingredient]) -> CheckIngredientViewController
  
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
  public init(
    viewModel: PictureIngredientViewModel,
    managePictureViewControllerFactory: @escaping () -> ManagePictureViewController,
    searchIngredientViewControllerFactory: @escaping () -> SearchIngredientViewController,
    checkIngredientViewControllerFactory: @escaping ([Ingredient]) -> CheckIngredientViewController
  ) {
    self.viewModel = viewModel
    self.makeManagePictureViewController = managePictureViewControllerFactory
    self.makeSearchIngredientViewController = searchIngredientViewControllerFactory
    self.makeCheckIngredientViewController = checkIngredientViewControllerFactory
    super.init()
    observeViewModel()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    view = PictureIngredientRootView(viewModel: viewModel)
    configureNavigationBar()
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let view = view as? PictureIngredientRootView {
      view.previewView.startRunning()
    }
  }
  
  public override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if let view = view as? PictureIngredientRootView {
      view.previewView.stopRunning()
    }
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
  
  private func observeViewModel() {
    viewModel.action.sink { [weak self] action in
      guard let strongSelf = self else { return }
      switch action {
        case .photoAlbum: strongSelf.presentPhotoAlbum()
        case .managePicture: strongSelf.presentManagePicture()
        case .checkIngredients(let ingredients):
          strongSelf.presentCheckIngredient(withIngredients: ingredients)
        case .community: print("present commnity.")
        case .search: strongSelf.presentSearchIngredient()
        case .notification: print("present notification.")
      }
    }.store(in: &bag)
  }
  
  private func presentPhotoAlbum() {
    let picker = ImagePickerController()
    picker.settings.selection.max = viewModel.remainingPictureCount
    
    presentImagePicker(picker, select: nil, deselect: nil, cancel: nil, finish: { assets in
      self.appendImageByAsset(assets)
    })
  }
  
  private func presentManagePicture() {
    let managePictureViewController = makeManagePictureViewController()
    navigationItem.backButtonTitle = ""
    navigationController?.pushViewController(managePictureViewController, animated: true)
  }
  
  private func presentCheckIngredient(withIngredients ingredients: [Ingredient]) {
    let checkIngredientViewController = makeCheckIngredientViewController(ingredients)
    checkIngredientViewController.modalTransitionStyle = .coverVertical
    checkIngredientViewController.modalPresentationStyle = .fullScreen
    present(checkIngredientViewController, animated: true)
  }
  
  private func presentSearchIngredient() {
    let searchIngredientViewController = makeSearchIngredientViewController()
    searchIngredientViewController.modalTransitionStyle = .crossDissolve
    searchIngredientViewController.modalPresentationStyle = .currentContext
    present(searchIngredientViewController, animated: true)
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
