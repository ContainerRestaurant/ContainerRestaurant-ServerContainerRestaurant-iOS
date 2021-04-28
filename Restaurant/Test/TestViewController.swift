//
//  TestViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/13.
//

import UIKit

class TestViewController: BaseViewController {
    @IBOutlet weak var mapTestButton: UIButton!
    @IBOutlet weak var loginTestButton: UIButton!
    @IBOutlet weak var popUpTestButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapTestButton.rx.tap
            .subscribe(onNext: { [self] _ in
                self.push(viewController: TestMapViewController())
            })
            .disposed(by: disposeBag)
        
        loginTestButton.rx.tap
            .subscribe(onNext: { [self] _ in
                if #available(iOS 13.0, *) {
                    self.push(viewController: TestLoginViewController())
                } else {
                    print("lower version")
                }
            })
            .disposed(by: disposeBag)

        popUpTestButton.rx.tap
            .subscribe(onNext: { [self] _ in
                let popupVC = TestPopUpViewController()
                popupVC.modalPresentationStyle = .overFullScreen
                present(popupVC, animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
    }

    deinit {
        print("TestViewController Deinit")
    }
}
