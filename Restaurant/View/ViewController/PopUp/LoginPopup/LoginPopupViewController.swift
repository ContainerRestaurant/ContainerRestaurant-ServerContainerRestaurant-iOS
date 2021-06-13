//
//  LoginPopupViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/14.
//

import UIKit
import RxSwift

class LoginPopupViewController: UIViewController, Storyboard {
    weak var coordinator: LoginPopupCoordinator?
    var disposeBag = DisposeBag()

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.presenter.tabBarController?.selectedIndex = 0 //임시로 0
                self?.dismiss(animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
    }

    deinit {
        print("LoginPopupViewController Deinit")
    }
}
