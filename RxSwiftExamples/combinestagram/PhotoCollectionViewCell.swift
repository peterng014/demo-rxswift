//
//  PhotoCollectionViewCell.swift
//  RxSwiftExamples
//
//  Created by Nguyen Phu on 8/8/18.
//  Copyright © 2018 Nguyen Phu. All rights reserved.
//

import UIKit
import Photos

class PhotoCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var imgView: UIImageView!
  var representedAssetIdentifier: String!
  
  override func prepareForReuse() {
    super.prepareForReuse()
    imgView.image = nil
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
  }
  
  func fetch(imageSize size: CGSize, contentMode: PHImageContentMode = .aspectFill, completionHandler: ((UIImage?, [AnyHashable : Any]?) -> Void)? = nil) {
    self.representedAssetIdentifier = viewModel.photo.localIdentifier
    viewModel.imageManager.requestImage(for: viewModel.photo, targetSize: size, contentMode: contentMode, options: nil) { [weak self] (image, data) in
      guard self?.representedAssetIdentifier == self?.viewModel.photo.localIdentifier else { return }
      if let handler = completionHandler {
        handler(image, data)
      } else {
        self?.imgView.image = image
      }
    }
  }
  
  func flash() {
    imgView.alpha = 0
    setNeedsDisplay()
    UIView.animate(withDuration: 0.5, animations: { [weak self] in
      self?.imgView.alpha = 1
    })
  }
  
  var viewModel: PhotoCollectionViewModel!
}

class PhotoCollectionViewModel: BaseViewModel {
  let imageManager = PHCachingImageManager()
  let photo: PHAsset!
  init(photo: PHAsset) {
    self.photo = photo
  }
  
}
