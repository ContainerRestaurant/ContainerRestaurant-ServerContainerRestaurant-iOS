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
    var isFromTapBar: Bool?
    var isFromMapBottomSheet = false

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if self?.isFromTapBar ?? false {
                    self?.coordinator?.presenter.tabBarController?.selectedIndex = 0 //임시로 0
                }
                self?.dismiss(animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
        
        kakaoLoginButton.rx.tap
            .subscribe(onNext: { [weak self] in
//                if self?.isFromMapBottomSheet ?? false {
//                    self?.dismiss(animated: false, completion: nil)
//                }
                self?.kakaoLogin()
            })
            .disposed(by: disposeBag)
        
        appleLoginButton.rx.tap
            .subscribe(onNext: { _ in
                print("애플 로그인 작업 필요")
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

                            APIClient.createLoginToken(provider: "KAKAO", accessToken: oAuthToken?.accessToken ?? "") {
                                if UserDataManager.sharedInstance.userID == $0.id && UserDataManager.sharedInstance.loginToken == $0.token {
                                    self?.dismiss(animated: true, completion: nil)
                                } else {
                                    UserDataManager.sharedInstance.userID = $0.id
                                    UserDataManager.sharedInstance.loginToken = $0.token

                                    if self?.isFromMapBottomSheet ?? false  {
                                        self?.isFromMapBottomSheet = false
                                        let nicknamePopup = NickNamePopupViewController.instantiate()
                                        nicknamePopup.isFromMapBottomSheet = true
                                        self?.present(nicknamePopup, animated: false, completion: nil)
                                    } else {
                                        self?.dismiss(animated: false, completion: nil)
                                        self?.coordinator?.presentNickNamePopup()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
