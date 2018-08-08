//
//  Navigator.swift
//  RxSwiftExamples
//
//  Created by Nguyen Phu on 8/8/18.
//  Copyright © 2018 Nguyen Phu. All rights reserved.
//

import Foundation
import UIKit
import Photos

struct Example {
  let name: String
  
  static let examples = [
    Example(name: "Combinestagram"),
    Example(name: "GitFeed"),
    Example(name: "OurPlanet"),
    Example(name: "WunderCast"),
    Example(name: "Twittee")
  ]
}

class Navigator {
  enum Segue {
    case main
    case combinestagram(Example)
    case photos(CIPhotosViewController)
    case gitFeed(Example)
    case ourPlanet(Example)
    case wundercast(Example)
    case twittee(Example)
  }
  
  lazy private var defaultStoryboard = UIStoryboard(name: "Main", bundle: nil)
  
  func show(segue: Segue, sender: UIViewController) {
    switch segue {
    case .main:
      let vm = ExamplesViewModel(examples: Example.examples)
      show(target: ExamplesViewController.createWith(navigator: self, storyboard: sender.storyboard ?? defaultStoryboard, viewModel: vm), sender: sender)
    case .combinestagram(let obj):
      let vm = CIMainViewModel()
      let target = CIMainViewController.createWith(navigator: self, storyboard: sender.storyboard ?? defaultStoryboard,viewModel: vm)
      target.title = obj.name
      show(target: target, sender: sender)
    case .photos(let target):
      show(target: target, sender: sender)
    case .gitFeed(let obj):
//      let vm = Git()
//      let target = G.createWith(navigator: self, storyboard: sender.storyboard ?? defaultStoryboard,viewModel: vm)
//      target.title = obj.name
//      show(target: target, sender: sender)
      print("\(obj.name)")
      
    default:
      break
    }
  }
  
  private func show(target: UIViewController, sender: UIViewController) {
    if let nav = sender as? UINavigationController {
      nav.setViewControllers([target], animated: true)
      return
    }
    if let nav = sender.navigationController {
      nav.pushViewController(target, animated: true)
    } else {
      sender.present(target, animated: true, completion: nil)
    }
  }
  
  
}
