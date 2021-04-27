//
//  BaseViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/13.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class BaseViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func push(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
