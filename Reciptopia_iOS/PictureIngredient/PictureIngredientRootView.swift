//
//  PictureIngredientRootView.swift
//  Reciptopia_iOS
//
//  Created by 김세영 on 2022/02/21.
//

import Foundation
import Combine
import Reciptopia_UIKit
import ReciptopiaKit
import SnapKit
import AVFoundation

public class PictureIngredientRootView: NiblessView {
  
  // MARK: - Dependencies
  let viewModel: PictureIngredientViewModel
  
  // MARK: - Properties
  private var bag = Set<AnyCancellable>()
  
  lazy var previewView: BackCameraView = {
    let view = BackCameraView()
    view.delegate = self
    return view
  }()
  
  lazy var maskingView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    return view
  }()
  
  let pictureCountButton: UIButton = {
    let button = UIButton()
    button.setTitle("0 / 10", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.setTitleFont(.systemFont(ofSize: 16))
    button.setImage(UIImage(systemName: "photo"), for: .normal)
    button.tintColor = .white
    return button
  }()
  
  let analyzeIngredientButton: UIButton = {
    let button = UIButton()
    button.setTitle("0개의 재료 분석하기", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.setTitleFont(.systemFont(ofSize: 16))
    button.backgroundColor = .accentColor
    button.layer.cornerRadius = 10
    button.contentEdgeInsets = .init(top: 8, left: 10, bottom: 8, right: 10)
    return button
  }()
  
  lazy var photoUtilStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [
      presentPhotoAlbumButton,
      takePhotoButton,
      torchButton,
    ])
    stack.axis = .horizontal
    stack.distribution = .fillEqually
    stack.spacing = 60
    return stack
  }()
  
  let presentPhotoAlbumButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "photo.circle"), for: .normal)
    button.setPreferredSymbolConfiguration(.init(pointSize: 40), forImageIn: .normal)
    button.tintColor = .black
    return button
  }()
  
  let takePhotoButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "camera.circle"), for: .normal)
    button.setPreferredSymbolConfiguration(.init(pointSize: 50), forImageIn: .normal)
    button.tintColor = .black
    return button
  }()
  
  let torchButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "flashlight.on.fill"), for: .normal)
    button.setPreferredSymbolConfiguration(.init(pointSize: 40), forImageIn: .normal)
    button.tintColor = .black
    return button
  }()
  
  // MARK: - Methods
  public init(frame: CGRect = .zero, viewModel: PictureIngredientViewModel) {
    self.viewModel = viewModel
    super.init(frame: frame)
    bindViewModel()
  }
  
  private func bindViewModel() {
    bindButtonStateToViewModel()
  }
  
  public override func didMoveToWindow() {
    super.didMoveToWindow()
    buildHierarchy()
    activateConstraints()
    addTargets()
  }
  
  private func buildHierarchy() {
    addSubview(previewView)
    addSubview(maskingView)
    maskingView.addSubview(pictureCountButton)
    maskingView.addSubview(analyzeIngredientButton)
    addSubview(photoUtilStack)
  }
  
  private func activateConstraints() {
    activateConstraintPreviewView()
    activateConstraintMaskingView()
    activateConstraintPhotoUtilStack()
  }
  
  private func addTargets() {
    addTargetAlbumButton()
    addTargetTorchButton()
    addTargetTakePhotoButton()
    addTargetPictureCountButton()
    addTargetAnalyzeIngredientButton()
  }
}

fileprivate extension PictureIngredientRootView {
  
  // MARK: - Bind ViewModel
  func bindButtonStateToViewModel() {
    viewModel.pictureIngredients
      .receive(on: DispatchQueue.main)
      .map { $0.count }
      .sink { [weak self] pictureCount in
        self?.analyzeIngredientButton.setTitle("\(pictureCount)개의 재료 분석하기", for: .normal)
        self?.pictureCountButton.setTitle("\(pictureCount) / 10", for: .normal)
      }.store(in: &bag)
    
    viewModel.pictureIngredients
      .receive(on: DispatchQueue.main)
      .map { (0..<10).contains($0.count) }
      .assign(to: \.isEnabled, on: takePhotoButton)
      .store(in: &bag)
    
    viewModel.pictureIngredients
      .receive(on: DispatchQueue.main)
      .map { $0.count > 0 }
      .sink { [weak self] isEnabled in
        self?.analyzeIngredientButton.isEnabled = isEnabled
        self?.pictureCountButton.isEnabled = isEnabled
      }.store(in: &bag)
  }
  
  // MARK: - Activate Constraints
  func activateConstraintPreviewView() {
    previewView.snp.makeConstraints { make in
      make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
      make.bottom.equalTo(photoUtilStack.snp.top).offset(-30)
    }
  }
  
  func activateConstraintMaskingView() {
    maskingView.snp.makeConstraints { make in
      make.leading.bottom.trailing.equalTo(previewView)
      make.height.equalTo(130)
    }
    
    pictureCountButton.snp.makeConstraints { make in
      make.centerX.equalTo(maskingView)
      make.top.equalTo(maskingView).offset(30)
    }
    
    analyzeIngredientButton.snp.makeConstraints { make in
      make.centerX.equalTo(maskingView)
      make.top.equalTo(pictureCountButton.snp.bottom).offset(20)
      make.bottom.equalTo(maskingView).offset(-30)
    }
  }
  
  func activateConstraintPhotoUtilStack() {
    photoUtilStack.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide).inset(15)
    }
  }
  
  // MARK: - Add Targets
  func addTargetPictureCountButton() {
    pictureCountButton.addTarget(
      viewModel,
      action: #selector(PictureIngredientViewModel.presentManagePicture),
      for: .touchUpInside
    )
  }
  
  func addTargetTakePhotoButton() {
    #if DEBUG
    takePhotoButton.addTarget(
      self,
      action: #selector(addTempImageData),
      for: .touchUpInside
    )
    #else
    takePhotoButton.addTarget(
      previewView,
      action: #selector(BackCameraView.takePhoto),
      for: .touchUpInside
    )
    #endif
  }
  
  @objc func addTempImageData() {
    guard let imageData = UIImage(systemName: "circle.fill")?.jpegData(compressionQuality: 1) else {
      return
    }
    viewModel.addPicture(imageData)
  }
  
  func addTargetTorchButton() {
    torchButton.addTarget(
      previewView,
      action: #selector(BackCameraView.toggleFlash),
      for: .touchUpInside
    )
  }
  
  func addTargetAlbumButton() {
    presentPhotoAlbumButton.addTarget(
      viewModel,
      action: #selector(PictureIngredientViewModel.presentPhotoAlbum),
      for: .touchUpInside
    )
  }
  
  func addTargetAnalyzeIngredientButton() {
    analyzeIngredientButton.addTarget(
      viewModel,
      action: #selector(PictureIngredientViewModel.analyzeIngredients),
      for: .touchUpInside
    )
  }
}

extension PictureIngredientRootView: AVCapturePhotoCaptureDelegate {
  public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    guard let imageData = photo.fileDataRepresentation() else { return }
    viewModel.addPicture(imageData)
  }
}
