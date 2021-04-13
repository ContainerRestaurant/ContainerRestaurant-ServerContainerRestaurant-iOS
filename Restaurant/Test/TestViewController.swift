//
//  TestViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/13.
//

import UIKit

class TestViewController: BaseViewController {
    @IBOutlet weak var mapTestButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapTestButton.rx.tap
            .subscribe(onNext: { [self] _ in
                self.push(viewController: TestMapViewController())
            })
            .disposed(by: disposeBag)
        
        print("second view did load")
    }
    
    deinit {
        print("TestViewController deinit")
    }
}
