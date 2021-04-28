//
//  TestPopUpViewController.swift
//  Restaurant
//
//  Created by Lotte on 2021/04/28.
//

import UIKit

class TestPopUpViewController: BaseViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        popUpView.layer.cornerRadius = 14

        cancelButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
    }

    deinit {
        print("TestPopUpViewController Deinit")
    }
}
