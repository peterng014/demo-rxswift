//
//  CIMainViewController.swift
//  RxSwiftExamples
//
//  Created by Nguyen Phu on 8/8/18.
//  Copyright © 2018 Nguyen Phu. All rights reserved.
//

import UIKit
import RxSwift
import Then

class CIMainViewController: UIViewController {
  
  static func createWith(navigator: Navigator, storyboard: UIStoryboard, viewModel: CIMainViewModel) -> CIMainViewController {
    return storyboard.instantiateViewController(ofType: CIMainViewController.self).then { vc in
      vc.navigator = navigator
      vc.viewModel = viewModel
    }
  }
  
  private let bag = DisposeBag()
  fileprivate var viewModel: CIMainViewModel!
  fileprivate var navigator: Navigator!
  
  @IBOutlet weak var previewImgView: UIImageView!
  @IBOutlet weak var clearButton: UIButton!
  @IBOutlet weak var saveButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViews()
    
    bindUI()
  }
  
}

extension CIMainViewController {
  
  func save(_ image: UIImage) -> Observable<Void> {
    return Observable.create({ observer in
      
      UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.didFinishSavingWithError(_:)), nil)
      return Disposables.create()
    })
  }
  
  @objc func didFinishSavingWithError(_ sender: Any) {
    print(sender)
  }
  
  
  func configureViews() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
  }
  
  func bindUI() {
    navigationItem.rightBarButtonItem!.rx.tap
      .throttle(0.5, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        guard let this = self else { return }
        let vm = CIPhotosViewModel(photos: CIPhotosViewModel.loadPhotos())
        let target = CIPhotosViewController.createWith(navigator: this.navigator, storyboard: this.storyboard!,viewModel: vm)
        target.selectedPhoto
          .subscribe(onNext: { newImage in
            this.viewModel.images.value.append(newImage)
          })
        .disposed(by: this.bag)
        this.navigator.show(segue: .photos(target), sender: this)
      })
    .disposed(by: bag)
    
    clearButton.rx.tap
      .throttle(0.2, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        self?.viewModel.images.value = []
      })
    .disposed(by: bag)
    
    saveButton.rx.tap
      .throttle(0.2, scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        guard let this = self,
          let image = this.previewImgView.image else { return }
        this.viewModel.images.value = []
      })
      .disposed(by: bag)
    
    viewModel.photoWriter
      .subscribe { (event) in
        print(event.isCompleted ? "Completed" : "Error")
    }
    .disposed(by: bag)
    
    let sharedImages = viewModel.images
    .asObservable()
    .throttle(0.5, scheduler: MainScheduler.instance)
    
    sharedImages
      .subscribe({ [weak self] event in
        guard let this = self,
          let imgs = event.element else { return }
        let photos = imgs.map { $0.image }
        this.previewImgView.image = UIImage.collage(images: photos, size: this.previewImgView.frame.size)
      })
    .disposed(by: bag)
    
    sharedImages
      .subscribe(onNext: { [weak self] photos in
        self?.clearButton.isEnabled = photos.count > 0
        self?.saveButton.isEnabled = photos.count > 0
      })
    .disposed(by: bag)
  }
}


class CIImageModel {
  var name: String
  var image: UIImage
  init(name: String, image: UIImage) {
    self.name = name
    self.image = image
  }
}
