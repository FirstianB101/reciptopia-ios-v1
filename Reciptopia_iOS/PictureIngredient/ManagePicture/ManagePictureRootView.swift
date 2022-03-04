//
//  ManagePictureRootView.swift
//  Reciptopia_iOS
//
//  Created by 김세영 on 2022/02/22.
//

import Reciptopia_UIKit
import ReciptopiaKit
import SnapKit
import Combine

public final class ManagePictureRootView: NiblessView {
  
  // MARK: - Dependencies
  let viewModel: PictureIngredientViewModel
  private var bag = Set<AnyCancellable>()
  
  // MARK: - Properties
  lazy var pictureCollection: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 10
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.allowsMultipleSelection = true
    collectionView.register(
      ManagePictureCell.self,
      forCellWithReuseIdentifier: ManagePictureCell.reuseIdentifier
    )
    return collectionView
  }()
  
  lazy var analyzeButton: UIButton = {
    let button = UIButton()
    button.setTitle("0개의 재료 분석하기", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.setTitleFont(.systemFont(ofSize: 20))
    button.backgroundColor = .accentColor
    button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    return button
  }()
  
  // MARK: - Methods
  public init(frame: CGRect = .zero, viewModel: PictureIngredientViewModel) {
    self.viewModel = viewModel
    super.init(frame: frame)
    bindViewModel()
  }
  
  private func bindViewModel() {
    viewModel.pictureIngredients
      .receive(on: DispatchQueue.main)
      .map { "\($0.count)개의 재료 분석하기" }
      .assign(to: \.titleForNormal, on: analyzeButton)
      .store(in: &bag)
    
    viewModel.pictureIngredients
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.pictureCollection.reloadData()
      }.store(in: &bag)
    
    viewModel.pictureIngredients
      .receive(on: DispatchQueue.main)
      .map { $0.count != 0 }
      .assign(to: \.isEnabledWithAlpha, on: analyzeButton)
      .store(in: &bag)
  }
  
  public override func didMoveToWindow() {
    super.didMoveToWindow()
    buildHierarchy()
    activateConstraints()
    addTargets()
  }
  
  private func buildHierarchy() {
    addSubview(pictureCollection)
    addSubview(analyzeButton)
  }
  
  private func activateConstraints() {
    pictureCollection.snp.makeConstraints { make in
      make.top.leading.trailing.equalTo(safeAreaLayoutGuide).inset(10)
      make.bottom.equalTo(analyzeButton.snp.top)
    }
    
    analyzeButton.snp.makeConstraints { make in
      make.leading.trailing.equalTo(safeAreaLayoutGuide)
      make.bottom.equalToSuperview()
      make.height.equalTo(80)
    }
  }
  
  private func addTargets() {
    analyzeButton.addTarget(
      viewModel,
      action: #selector(PictureIngredientViewModel.analyzeIngredients),
      for: .touchUpInside
    )
  }
}

extension ManagePictureRootView:
  UICollectionViewDelegate,
  UICollectionViewDataSource,
  UICollectionViewDelegateFlowLayout
{
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.pictureIngredients.value.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: ManagePictureCell.reuseIdentifier,
      for: indexPath
    ) as? ManagePictureCell else { return UICollectionViewCell() }
    let imageData = viewModel.pictureIngredients.value[indexPath.item]
    cell.configureCell(imageData)
    
    return cell
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let sideLength = UIScreen.main.bounds.width / 2 - 15
    return CGSize(width: sideLength, height: sideLength)
  }
  
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = dequeueManagePictureCell(collectionView, at: indexPath)
    viewModel.addDeletion(at: indexPath.item)
    cell.selectCell()
  }
  
  public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    let cell = dequeueManagePictureCell(collectionView, at: indexPath)
    viewModel.removeDeletion(at: indexPath.item)
    cell.deselectCell()
  }
  
  private func dequeueManagePictureCell(_ collectionView: UICollectionView, at indexPath: IndexPath) -> ManagePictureCell {
    guard let cell = collectionView.cellForItem(at: indexPath) as? ManagePictureCell else {
      return ManagePictureCell()
    }
    return cell
  }
}
