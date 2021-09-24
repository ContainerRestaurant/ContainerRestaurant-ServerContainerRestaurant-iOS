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
    var isFromMapBottomSheet = false
    var beforeTextLength = 0
    var totalTextLength = 0

    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var nicknameValidationCheckLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindingView()
    }
    
    private func bindingView() {
        self.validateNicknameSubject
            .map { !$0 }
            .subscribe(onNext: { [weak self] isValidate in
                self?.nicknameValidationCheckLabel.textColor = isValidate ? .colorMainGreen03 : .colorPointOrange02
                self?.nicknameValidationCheckLabel.text = isValidate ? "사용 가능한 닉네임 입니다" : "중복 닉네임 입니다."
                self?.registerButton.isEnabled = isValidate
                self?.registerButton.backgroundColor = isValidate ? .colorMainGreen03 : .colorGrayGray03
                self?.registerButton.setTitleColor(isValidate ? .colorGrayGray01 : .colorGrayGray06, for: .normal)
            })
            .disposed(by: disposeBag)

        nickNameTextField.rx.text
            .subscribe(onNext: { [weak self] textInField in
                guard let `self` = self else { return }

                if let text = textInField {
                    if text == "" {
                        self.nicknameValidationCheckLabel.text = ""
                        self.setUnableRegisterButton()
                        return
                    }
                    let nicknameReg = "[가-힣A-Za-z0-9]{0,}"
                    let nicknameLengthReg = "[가-힣A-Za-z0-9]{0,10}"
                    let pred = NSPredicate(format:"SELF MATCHES %@", nicknameReg)
                    let lengthPred = NSPredicate(format:"SELF MATCHES %@", nicknameLengthReg)

                    if !pred.evaluate(with: text) {
                        self.nicknameValidationCheckLabel.textColor = .colorPointOrange02
                        self.nicknameValidationCheckLabel.text = "한글/영문/숫자만 입력해 주세요"
                        self.setUnableRegisterButton()
                    } else if !lengthPred.evaluate(with: text) {
                        self.nicknameValidationCheckLabel.textColor = .colorPointOrange02
                        self.nicknameValidationCheckLabel.text = "1~10자 이내로 입력해 주세요"
                        self.setUnableRegisterButton()
                    } else {
                        API().validateNickName(nickName: text, subject: self.validateNicknameSubject)
                    }
                }
            })
            .disposed(by: disposeBag)

        registerButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let userID = UserDataManager.sharedInstance.userID
                let nickname = self?.nickNameTextField.text ?? ""

                APIClient.updateUserInformation(userID: userID, nickname: nickname) {
                    print("업데이트 됐따")
                    print($0)
                    print("업데이트 됐따")
                }

                if self?.isFromMapBottomSheet ?? false {
                    self?.isFromMapBottomSheet = false
                    self?.dismiss(animated: true) {
                        Common.currentViewController()?.dismiss(animated: false) {
                            Common.currentViewController()?.dismiss(animated: false) {
                                print("Todo: 탭바 인덱스 0으로 보내기")
                            }
                        }
                    }
                } else {
                    self?.coordinator?.presenter.tabBarController?.selectedIndex = 0
                    self?.dismiss(animated: true, completion: nil)
                }
            })
            .disposed(by: disposeBag)
    }

    private func setUnableRegisterButton() {
        self.registerButton.isEnabled = false
        self.registerButton.backgroundColor = .colorGrayGray03
        self.registerButton.setTitleColor(.colorGrayGray06, for: .normal)
    }
    
    deinit {
        print("NickNamePopupViewController Deinit")
    }
}
