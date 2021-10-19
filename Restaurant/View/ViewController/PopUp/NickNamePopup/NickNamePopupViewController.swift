//
//  NickNamePopupViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/15.
//

import UIKit
import RxSwift

enum ViewControllerWhereComeFrom {
    case mapBottomSheet
    case myNicknameUpdate
    case normal
}

class NickNamePopupViewController: BaseViewController, Storyboard {
    weak var coordinator: NickNamePopupCoordinator?
    var validateNicknameSubject: PublishSubject<Bool> = PublishSubject<Bool>()
    var viewControllerWhereComeFrom: ViewControllerWhereComeFrom = .normal
    var beforeTextLength = 0
    var totalTextLength = 0

    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var nicknameValidationCheckLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindingView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.coordinator?.presenter.setNavigationBarHidden(false, animated: true)

        let backImage = UIImage(named: "chevronLeftOutline20Px")
        self.coordinator?.presenter.navigationBar.backIndicatorImage = backImage
        self.coordinator?.presenter.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.coordinator?.presenter.navigationBar.backItem?.title = ""
        self.coordinator?.presenter.navigationBar.tintColor = .colorGrayGray08

        //self.coordinator?.presenter.navigationItem.title = "닉네임 수정" Todo: 얜 왜 안되는지 밑에랑 무슨 차인지 (현재는 coordinator에 선언해놨음)
//        self.navigationItem.title = "닉네임 수정"
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

                APIClient.updateUserInformation(userID: userID, nickname: nickname) { [weak self] _ in
                    switch self?.viewControllerWhereComeFrom {
                    case .mapBottomSheet:
                        self?.dismiss(animated: true) {
                            Common.currentViewController()?.dismiss(animated: false) {
                                Common.currentViewController()?.dismiss(animated: false) {
                                    print("Todo: 탭바 인덱스 0으로 보내기")
                                }
                            }
                        }
                    case .myNicknameUpdate:
                        self?.coordinator?.presenter.popViewController(animated: true)
                        ToastMessage.shared.show(str: "닉네임 변경이 완료되었습니다.")
                    case .normal:
                        self?.coordinator?.presenter.tabBarController?.selectedIndex = 0
                        self?.dismiss(animated: true, completion: nil)
                    default: break
                    }
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
