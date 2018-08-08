//
//  PhotoWriter.swift
//  RxSwiftExamples
//
//  Created by Nguyen Phu on 8/8/18.
//  Copyright © 2018 Nguyen Phu. All rights reserved.
//

import UIKit
import RxSwift

class PhotoWriter: NSObject {
  typealias CallBack = (NSError?) -> Void
  
  private var callback: CallBack
  
  init(callback: @escaping CallBack) {
    self.callback = callback
  }    
  
  
}
