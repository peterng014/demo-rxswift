//
//  CIMainViewModel.swift
//  RxSwiftExamples
//
//  Created by Nguyen Phu on 8/8/18.
//  Copyright © 2018 Nguyen Phu. All rights reserved.
//

import Foundation
import RxSwift

class CIMainViewModel: BaseViewModel {
  var images = Variable<[CIImageModel]>([])
  var photoWriter: Observable<Void>!
}

