//
//  CheckIngredientRootView.swift
//  Reciptopia_iOS
//
//  Created by 김세영 on 2022/03/02.
//

import Foundation
import Combine
import Reciptopia_UIKit
import ReciptopiaKit
import SnapKit

public class CheckIngredientRootView: NiblessView {
  
  // MARK: - Dependencies
  let viewModel: SearchIngredientViewModel
  
  // MARK: - Properties
  var bag = Set<AnyCancellable>()
  
  lazy var titleStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [analyzeLabel, dismissButton])
    stack.axis = .horizontal
    stack.distribution = .fillProportionally
    return stack
  }()
  
  lazy var analyzeLabel: UILabel = {
    let label = UILabel()
    label.text = "재료를 분석했어요."
    label.textColor = .black
    label.font = .boldSystemFont(ofSize: 27)
    return label
  }()
  
  lazy var dismissButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "xmark"), for: .normal)
    button.tintColor = .black
    return button
  }()
  
  lazy var hintLabelStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [checkIngredientLabel, hintLabel])
    stack.axis = .vertical
    stack.spacing = 15
    return stack
  }()
  
  lazy var checkIngredientLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = .systemFont(ofSize: 16)
    label.text = "재료가 맞는지 확인해주세요."
    return label
  }()
  
  lazy var hintLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = .systemFont(ofSize: 16)
    label.lineBreakMode = .byWordWrapping
    label.numberOfLines = 0
    let hintString = "핵심 재료를 체크하면 해당 재료는 검색에 반드시 포함됩니다."
    let mainIngredientString = "핵심 재료"
    let range = (hintString as NSString).range(of: mainIngredientString)
    let attributedString = NSMutableAttributedString(string: hintString)
    attributedString.addAttributes([.foregroundColor: UIColor.mainIngredient], range: range)
    label.attributedText = attributedString
    
    return label
  }()
  
  lazy var ingredientsCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 15
    layout.scrollDirection = .vertical
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(
      IngredientCell.self,
      forCellWithReuseIdentifier: IngredientCell.reuseIdentifier
    )
    
    return collectionView
  }()
  
  lazy var searchByIngredientButton: UIButton = {
    let button = UIButton()
    button.setTitle("레시피 찾기", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.setTitleFont(.systemFont(ofSize: 20))
    button.backgroundColor = .accentColor
    button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    return button
  }()
  
  // MARK: - Methods
  public init(frame: CGRect = .zero, viewModel: SearchIngredientViewModel) {
    self.viewModel = viewModel
    super.init(frame: frame)
    bindViewModel()
  }
  
  public override func didMoveToWindow() {
    super.didMoveToWindow()
    buildHierarchy()
    activateConstraints()
    addTargets()
  }
  
  public func bindViewModel() {
    viewModel.$ingredients
      .receive(on: DispatchQueue.main)
      .sink { [weak self] ingredients in
        self?.ingredientsCollectionView.reloadData()
      }.store(in: &bag)
  }
  
  private func buildHierarchy() {
    addSubview(titleStack)
    addSubview(hintLabelStack)
    addSubview(ingredientsCollectionView)
    addSubview(searchByIngredientButton)
  }
  
  private func activateConstraints() {
    activateConstraintsTitleStack()
    activateConstraintsHintLabelStack()
    activateConstraintsIngredientsCollectionView()
    activateConstraintsSearchByIngredientButton()
  }
  
  private func addTargets() {
    dismissButton.addTarget(
      viewModel,
      action: #selector(SearchIngredientViewModel.dismiss),
      for: .touchUpInside
    )
    
    searchByIngredientButton.addTarget(
      viewModel,
      action: #selector(SearchIngredientViewModel.searchByIngredients),
      for: .touchUpInside
    )
  }
}

extension CheckIngredientRootView {
  private func activateConstraintsTitleStack() {
    titleStack.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide).inset(30)
      make.leading.trailing.equalToSuperview().inset(30)
    }
  }
  
  private func activateConstraintsHintLabelStack() {
    hintLabelStack.snp.makeConstraints { make in
      make.top.equalTo(titleStack.snp.bottom).offset(50)
      make.leading.trailing.equalToSuperview().inset(30)
    }
  }
  
  private func activateConstraintsIngredientsCollectionView() {
    ingredientsCollectionView.snp.makeConstraints { make in
      make.top.equalTo(hintLabel.snp.bottom).offset(30)
      make.leading.trailing.equalToSuperview().inset(40)
      make.bottom.equalTo(safeAreaLayoutGuide)
    }
  }
  
  private func activateConstraintsSearchByIngredientButton() {
    searchByIngredientButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
      make.height.equalTo(80)
    }
  }
}

extension CheckIngredientRootView:
  UICollectionViewDelegate,
  UICollectionViewDataSource,
  UICollectionViewDelegateFlowLayout
{
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.ingredients.count
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: IngredientCell.reuseIdentifier,
      for: indexPath
    ) as? IngredientCell else { return UICollectionViewCell() }
    
    let ingredient = viewModel.ingredients[indexPath.item]
    cell.configureCell(name: ingredient.name, isMainIngredient: ingredient.isMainIngredient)
    cell.removeHandler = { [weak self] in
      self?.viewModel.removeIngredient(at: indexPath.item)
      self?.ingredientsCollectionView.reloadData()
    }
    
    return cell
  }
  
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? IngredientCell else { return }
    viewModel.toggleMainOrSubIngredient(at: indexPath.item)
    
    let ingredient = viewModel.ingredients[indexPath.item]
    cell.configureCell(name: ingredient.name, isMainIngredient: ingredient.isMainIngredient)
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = UIScreen.main.bounds.width - 80
    let height: CGFloat = 50
    
    return CGSize(width: width, height: height)
  }
}
