//
//  LoginPopupViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/14.
//

import UIKit
import RxSwift
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class LoginPopupViewController: UIViewController, Storyboard {
    weak var coordinator: LoginPopupCoordinator?
    var disposeBag = DisposeBag()

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.presenter.tabBarController?.selectedIndex = 0 //임시로 0
                self?.dismiss(animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
        
        kakaoLoginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.kakaoLogin()
            })
            .disposed(by: disposeBag)
        
        appleLoginButton.rx.tap
            .subscribe(onNext: { _ in
                API().askUser()
            })
            .disposed(by: disposeBag)
        
        logoutButton.rx.tap
            .subscribe(onNext: { _ in
                API().logoutUser()
            })
            .disposed(by: disposeBag)
    }

    deinit {
        print("LoginPopupViewController Deinit")
    }
}

extension LoginPopupViewController {
    private func kakaoLogin() {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk {(oAuthToken, error) in
                if let error = error {
                    print("로그인 여부\(error)")
                } else {
                    print("loginWithKakaoTalk() success.")
                    
                    UserApi.shared.me() { [weak self] (user, error) in
                        if let error = error {
                            print("사용자 정보 가져오기 \(error)")
                        } else {
                            print("me() success.")
                            print("엑세스토큰: \(oAuthToken?.accessToken)")
                            API().createUser(provider: "KAKAO", accessToken: oAuthToken?.accessToken ?? "")
                            
                            self?.dismiss(animated: false, completion: nil)
                            self?.coordinator?.presentNickNamePopup()
                        }
                    }
                }
            }
        }
    }
}
