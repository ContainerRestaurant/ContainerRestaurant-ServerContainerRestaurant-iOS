//
//  TestPopUpViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/28.
//

import UIKit
import RxSwift

class TestPopUpViewController: BaseViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        popUpView.layer.cornerRadius = 14

        cancelButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: nil)
            }, onDisposed: {
                print("onDisposed-cancelButton")
            })
            .disposed(by: disposeBag)

        okButton.rx.tap
            .subscribe(onNext: {
                print("좋아요!")
            }, onDisposed: {
                print("onDisposed-okButton")
            })
            .disposed(by: disposeBag)
    }

//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        disposeBag = DisposeBag()
//    }

    deinit {
        print("TestPopUpViewController Deinit")
    }
}
