//
//  SearchIngredientRootView.swift
//  Reciptopia_iOS
//
//  Created by 김세영 on 2022/02/23.
//

import Combine
import Reciptopia_UIKit
import ReciptopiaKit
import SnapKit

public final class SearchIngredientRootView: NiblessView {
  
  // MARK: - Dependencies
  let viewModel: SearchIngredientViewModel
  let searchHistoryRootView: SearchHistoryRootView
  let favoriteBoardRootView: FavoriteBoardRootView
  
  // MARK: - Properties
  var bag = Set<AnyCancellable>()
  
  lazy var titleStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [searchBar, dismissButton])
    stack.axis = .horizontal
    stack.distribution = .fill
    return stack
  }()
  
  lazy var dismissButton: UIButton = {
    let button = UIButton()
    button.setTitle("취소", for: .normal)
    button.setTitleFont(.systemFont(ofSize: 15))
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  
  lazy var searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.placeholder = "재료 추가"
    searchBar.returnKeyType = .default
    searchBar.enablesReturnKeyAutomatically = true
    searchBar.delegate = self
    searchBar.backgroundImage = UIImage()
//    searchBar.becomeFirstResponder()
    return searchBar
  }()
  
  lazy var ingredientsCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 7
    layout.scrollDirection = .horizontal
    layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    layout.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .collectionBackground
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(
      IngredientCell.self,
      forCellWithReuseIdentifier: IngredientCell.reuseIdentifier
    )
    
    return collectionView
  }()
  
  lazy var historyAndFavoriteViewPager: PagingSegmentedControl = {
    let segmentedControl = PagingSegmentedControl()
    let historySegment = SearchIngredientAction.history.rawValue
    let favoriteSegment = SearchIngredientAction.favorite.rawValue
    segmentedControl.insertSegment(withTitle: "검색 기록", at: historySegment, animated: false)
    segmentedControl.insertSegment(withTitle: "즐겨찾기", at: favoriteSegment, animated: false)
    segmentedControl.selectedSegmentIndex = historySegment
    return segmentedControl
  }()
  
  lazy var searchButton: FloatingButton = {
    let button = FloatingButton(size: 50)
    button.setImage(UIImage(systemName: "magnifyingglass"))
    return button
  }()
  
  // MARK: - Methods
  public init(
    frame: CGRect = .zero,
    viewModel: SearchIngredientViewModel,
    searchHistoryRootView: SearchHistoryRootView,
    favoriteBoardRootView: FavoriteBoardRootView
  ) {
    self.viewModel = viewModel
    self.searchHistoryRootView = searchHistoryRootView
    self.favoriteBoardRootView = favoriteBoardRootView
    super.init(frame: frame)
    bindViewModel()
  }
  
  public override func didMoveToWindow() {
    super.didMoveToWindow()
    buildHierarchy()
    activateConstraints()
    addTargets()
  }
  
  private func bindViewModel() {
    viewModel.$ingredients
      .receive(on: DispatchQueue.main)
      .sink { [weak self] ingredients in
        self?.ingredientsCollectionView.reloadData()
        self?.searchButton.isEnabledWithAlpha = !ingredients.isEmpty
      }.store(in: &bag)
    
    viewModel.action
      .receive(on: DispatchQueue.main)
      .sink { [weak self] action in
        switch action {
          case .history: self?.presentSearchHistory()
          case .favorite: self?.presentFavoriteBoard()
          case .dismiss: break
        }
      }.store(in: &bag)
  }
  
  private func presentSearchHistory() {
    searchHistoryRootView.isHidden = false
    favoriteBoardRootView.isHidden = true
  }
  
  private func presentFavoriteBoard() {
    searchHistoryRootView.isHidden = true
    favoriteBoardRootView.isHidden = false
  }
  
  private func buildHierarchy() {
    addSubview(titleStack)
    addSubview(ingredientsCollectionView)
    addSubview(historyAndFavoriteViewPager)
    addSubview(searchHistoryRootView)
    addSubview(favoriteBoardRootView)
    addSubview(searchButton)
  }
  
  private func activateConstraints() {
    activateConstraintsTitleStack()
    activateConstraintsIngredientCollectionView()
    activateConstraintsHistoryAndFavoriteViewPager()
    activateConstraintsSearchHistoryRootView()
    activateConstraintsFavoriteBoardRootView()
    activateConstraintsSearchButton()
  }
  
  private func addTargets() {
    dismissButton.addTarget(
      viewModel,
      action: #selector(SearchIngredientViewModel.dismiss),
      for: .touchUpInside
    )
    
    historyAndFavoriteViewPager.addTarget(
      self,
      action: #selector(viewPagerDidChangeValue),
      for: .valueChanged
    )
    
    searchButton.addTarget(
      viewModel,
      action: #selector(SearchIngredientViewModel.searchByIngredients),
      for: .touchUpInside
    )
  }
  
  @objc private func viewPagerDidChangeValue() {
    viewModel.changeView(at: historyAndFavoriteViewPager.selectedSegmentIndex)
  }
}

extension SearchIngredientRootView {
  private func activateConstraintsTitleStack() {
    titleStack.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide)
      make.leading.trailing.equalToSuperview().inset(10)
    }
  }
  
  private func activateConstraintsIngredientCollectionView() {
    ingredientsCollectionView.snp.makeConstraints { make in
      make.top.equalTo(titleStack.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(50)
    }
  }
  
  private func activateConstraintsHistoryAndFavoriteViewPager() {
    historyAndFavoriteViewPager.snp.makeConstraints { make in
      make.top.equalTo(ingredientsCollectionView.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(40)
    }
  }
  
  private func activateConstraintsSearchHistoryRootView() {
    searchHistoryRootView.snp.makeConstraints { make in
      make.top.equalTo(historyAndFavoriteViewPager.snp.bottom)
      make.leading.bottom.trailing.equalToSuperview()
    }
  }
  
  private func activateConstraintsFavoriteBoardRootView() {
    favoriteBoardRootView.snp.makeConstraints { make in
      make.top.equalTo(historyAndFavoriteViewPager.snp.bottom)
      make.leading.bottom.trailing.equalToSuperview()
    }
  }
  
  private func activateConstraintsSearchButton() {
    searchButton.snp.makeConstraints { make in
      make.trailing.equalTo(safeAreaLayoutGuide).inset(30)
      make.bottom.equalTo(safeAreaLayoutGuide).inset(10)
    }
  }
}

// MARK: - SearchBar Delegate
extension SearchIngredientRootView: UISearchBarDelegate {
  public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let text = searchBar.text else { return }
    viewModel.addIngredient(text)
    searchBar.text = ""
  }
}

// MARK: - IngredientCollectionView Delegate + DataSource
extension SearchIngredientRootView:
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
}
