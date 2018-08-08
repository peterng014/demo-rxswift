//
//  GFMainViewController.swift
//  RxSwiftExamples
//
//  Created by Nguyen Phu on 8/8/18.
//  Copyright © 2018 Nguyen Phu. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GFMainViewController: UIViewController {
  
  static func createWith(navigator: Navigator, storyboard: UIStoryboard, viewModel: Any? = nil) -> GFMainViewController {
    return storyboard.instantiateViewController(ofType: GFMainViewController.self).then { vc in
      vc.navigator = navigator
      vc.viewModel = viewModel
    }
  }
  
  private let bag = DisposeBag()
  fileprivate var viewModel: Any!
  fileprivate var navigator: Navigator!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
}
