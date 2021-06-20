//
//  NickNamePopupViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/15.
//

import UIKit
import RxSwift

class NickNamePopupViewController: BaseViewController, Storyboard {
    weak var coordinator: NickNamePopupCoordinator?
    var validateNicknameSubject: PublishSubject<Bool> = PublishSubject<Bool>()

    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindingView()
    }
    
    private func bindingView() {
        self.validateNicknameSubject
            .map { !$0 }
            .subscribe(onNext: { [weak self] isValidate in
                self?.registerButton.isEnabled = isValidate
                self?.registerButton.backgroundColor = isValidate ? .colorMainGreen03 : .colorGrayGray03
                self?.registerButton.setTitleColor(isValidate ? .colorGrayGray01 : .colorGrayGray06, for: .normal)
            })
            .disposed(by: disposeBag)

        nickNameTextField.rx.text
            .subscribe(onNext: { [weak self] textInField in
                guard let `self` = self else { return }

                if let text = textInField {
                    API().validateNickName(nickName: text, subject: self.validateNicknameSubject)
                }
            })
            .disposed(by: disposeBag)

        registerButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let userID = UserDataManager.sharedInstance.userID
                API().updateNickname(userID: userID, nickname: self?.nickNameTextField.text ?? "")
                self?.coordinator?.presenter.tabBarController?.selectedIndex = 0
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        print("NickNamePopupViewController Deinit")
    }
}
