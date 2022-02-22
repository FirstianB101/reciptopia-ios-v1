//
//  ManagePictureCell.swift
//  Reciptopia_iOS
//
//  Created by 김세영 on 2022/02/22.
//

import UIKit
import SnapKit

final class ManagePictureCell: UICollectionViewCell {
  
  // MARK: - Properties
  static let reuseIdentifier = String(describing: ManagePictureCell.self)
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .lightGray
    return imageView
  }()
  
  let selectedView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "checkmark.circle.fill")
    imageView.tintColor = .accentColor
    imageView.isHidden = true
    return imageView
  }()
  
  // MARK: - Methods
  override func didMoveToWindow() {
    super.didMoveToWindow()
    
    addSubview(imageView)
    imageView.addSubview(selectedView)
    
    imageView.snp.makeConstraints { make in
      make.top.leading.bottom.trailing.equalToSuperview()
    }
    selectedView.snp.makeConstraints { make in
      make.bottom.trailing.equalToSuperview().inset(15)
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    deselectCell()
  }
  
  func configureCell(_ imageData: Data) {
    let image = UIImage(data: imageData)
    imageView.image = image
    imageView.contentMode = .scaleAspectFit
  }
  
  func selectCell() {
    selectedView.isHidden = false
  }
  
  func deselectCell() {
    selectedView.isHidden = true
  }
}
