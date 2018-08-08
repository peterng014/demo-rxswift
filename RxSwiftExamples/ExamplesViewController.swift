//
//  ExamplesViewController.swift
//  RxSwiftExamples
//
//  Created by Nguyen Phu on 8/8/18.
//  Copyright © 2018 Nguyen Phu. All rights reserved.
//

import UIKit
import Then
import RxSwift
import RxCocoa

class ExamplesViewController: UIViewController {
  
  private let bag = DisposeBag()
  fileprivate var examplesViewModel: ExamplesViewModel!
  fileprivate var navigator: Navigator!
  
  fileprivate let cellIdentifier = "ExampleCell"
  
  static func createWith(navigator: Navigator, storyboard: UIStoryboard, viewModel: ExamplesViewModel) -> ExamplesViewController {
    return storyboard.instantiateViewController(ofType: ExamplesViewController.self).then { vc in
      vc.navigator = navigator
      vc.examplesViewModel = viewModel
    }
  }
  
  @IBOutlet var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
  
    bindUI()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print("RxSwift resource : \(RxSwift.Resources.total)")
  }
  
}

extension ExamplesViewController {
  func bindUI() {
    examplesViewModel.examples
    .asObservable()
      .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: UITableViewCell.self)) { row, exam, cell in
        cell.detailTextLabel?.text = exam.name
        cell.textLabel?.text = String(format: "%2d", row+1)
    }
    .disposed(by: bag)
    
    Observable
      .zip(tableView.rx.itemSelected, tableView.rx.modelSelected(Example.self))
      .bind { [weak self] indexPath, model in
        self?.tableView.deselectRow(at: indexPath, animated: true)
        guard let this = self else { return }
        switch indexPath.row {
        case 0:
          self?.navigator.show(segue: .combinestagram(model), sender: this)
        case 1:
          self?.navigator.show(segue: .gitFeed(model), sender: this)
        case 2:
          self?.navigator.show(segue: .ourPlanet(model), sender: this)
        case 3:
          self?.navigator.show(segue: .wundercast(model), sender: this)
        case 4:
          self?.navigator.show(segue: .twittee(model), sender: this)
        default:
          break
        }
    }
    .disposed(by: bag)
  }
  
  func registerCell() {
    
  }
  
  func configureTableView() {
    title = "Examples"
    registerCell()
    tableView.rowHeight = 50
  }
}

class ExamplesViewModel: BaseViewModel {
  
  let examples = Variable<[Example]>([])
  
  init(examples: [Example]) {
    super.init()
    self.examples.value = examples
  }
}
