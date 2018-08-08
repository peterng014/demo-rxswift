//
//  CIPhotosViewModel.swift
//  RxSwiftExamples
//
//  Created by Nguyen Phu on 8/8/18.
//  Copyright © 2018 Nguyen Phu. All rights reserved.
//

import Foundation
import RxSwift
import Photos

class CIPhotosViewModel: BaseViewModel {
  var selectedPhotoSubject = PublishSubject<CIImageModel>()
  var photos: PHFetchResult<PHAsset>!
  lazy var imageManager = PHCachingImageManager()
  
  static func loadPhotos() -> PHFetchResult<PHAsset> {
    let allPhotosOptions = PHFetchOptions()
    allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
    let results = PHAsset.fetchAssets(with: allPhotosOptions)
    return results
  }
  
  init(photos: PHFetchResult<PHAsset>) {
    self.photos = photos
  }
}
