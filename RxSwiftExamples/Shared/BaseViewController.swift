//
//  BaseViewController.swift
//  RxSwiftExamples
//
//  Created by Nguyen Phu on 8/8/18.
//  Copyright © 2018 Nguyen Phu. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import Then

protocol BaseViewControllerProtocol {
  func configureViews()
  func bindUIs()
}

class BaseViewController: UIViewController {
}
