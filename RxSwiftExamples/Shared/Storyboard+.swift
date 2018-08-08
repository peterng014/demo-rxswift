//
//  Storyboard+.swift
//  RxSwiftExamples
//
//  Created by Nguyen Phu on 8/8/18.
//  Copyright © 2018 Nguyen Phu. All rights reserved.
//

import Foundation

#if os(iOS)
import UIKit

extension UIStoryboard {
  func instantiateViewController<T>(ofType type: T.Type) -> T {
    return instantiateViewController(withIdentifier: String(describing: type)) as! T
  }
}
#elseif os(OSX)
import Cocoa

extension NSStoryboard {
  func instantiateViewController<T>(ofType type: T.Type) -> T {
    return instantiateController(withIdentifier: String(describing: type)) as! T
  }
}
#endif
