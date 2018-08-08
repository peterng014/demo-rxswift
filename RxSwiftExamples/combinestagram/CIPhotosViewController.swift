//
//  CIPhotosViewController.swift
//  RxSwiftExamples
//
//  Created by Nguyen Phu on 8/8/18.
//  Copyright © 2018 Nguyen Phu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Photos

class CIPhotosViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  static func createWith(navigator: Navigator, storyboard: UIStoryboard, viewModel: CIPhotosViewModel) -> CIPhotosViewController {
    return storyboard.instantiateViewController(ofType: CIPhotosViewController.self).then { vc in
      vc.navigator = navigator
      vc.viewModel = viewModel
    }
  }
  
  private let bag = DisposeBag()
  fileprivate var viewModel: CIPhotosViewModel!
  fileprivate var navigator: Navigator!
  fileprivate let cellIdentifier = "PhotoCollectionViewCell"
  private lazy var thumbnailSize: CGSize = {
    let cellSize = (self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
    return CGSize(width: cellSize.width * UIScreen.main.scale,
                  height: cellSize.height * UIScreen.main.scale)
  }()
  
  
  var selectedPhoto: Observable<CIImageModel> {
    return viewModel.selectedPhotoSubject.asObservable()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    bindUIs()
  }
}

extension CIPhotosViewController: BaseViewControllerProtocol {
  func configureViews() {
  }
  
  func bindUIs() {
//    viewModel.photos
//    .asObservable()
//      .bind(to: collectionView.rx.items(cellIdentifier: cellIdentifier, cellType: PhotoCollectionViewCell.self)) { [weak self]  row, p, cell in
//        guard let this = self else { return }
//        cell.viewModel = PhotoCollectionViewModel(photo: p)
//        cell.fetch(imageSize: this.thumbnailSize)
//    }
//    .disposed(by: bag)
  }
}


extension CIPhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.photos.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? PhotoCollectionViewCell {
      let asset = viewModel.photos[indexPath.row]
      cell.viewModel = PhotoCollectionViewModel(photo: asset)
      cell.fetch(imageSize: thumbnailSize)
      return cell
    }
    return UICollectionViewCell()
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell {
      cell.flash()
      let viewSize = collectionView.frame.size
      cell.fetch(imageSize: viewSize, contentMode: .aspectFill) { [weak self] (image, info) in
        guard let image = image, let info = info else { return }
        if let isThumbnail = info[PHImageResultIsDegradedKey as NSString] as? Bool,
          !isThumbnail {
          self?.viewModel.selectedPhotoSubject.onNext(CIImageModel(name: cell.representedAssetIdentifier, image: image))
        }
      }
    }
  }
  
}
