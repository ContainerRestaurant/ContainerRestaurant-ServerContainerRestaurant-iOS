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
import AuthenticationServices

enum loginPopupFromWhere {
    case feedDetail
    case mapBottomSheet
    case none
}

class LoginPopupViewController: UIViewController, Storyboard {
    weak var coordinator: LoginPopupCoordinator?
    var disposeBag = DisposeBag()
    var isFromTapBar: Bool?
    var fromWhere: loginPopupFromWhere = .none
    var feedDetailViewWillAppearSubject: PublishSubject<Void>?

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
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
                self.appleLogin()
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
                                UserDataManager.sharedInstance.userID = $0.id
                                UserDataManager.sharedInstance.loginToken = $0.token
                                UserDataManager.sharedInstance.fromWhereLogin = "kakao"

                                if $0.isNicknameNull {
                                    if self?.fromWhere == .mapBottomSheet  {
                                        let nicknamePopup = NickNamePopupViewController.instantiate()
                                        nicknamePopup.viewControllerWhereComeFrom = .mapBottomSheet
                                        self?.present(nicknamePopup, animated: false, completion: nil)
                                    } else {
                                        self?.dismiss(animated: false, completion: nil)
                                        self?.coordinator?.presentNickNamePopup()
                                    }
                                } else {
                                    self?.dismiss(animated: true, completion: nil)
                                    if self?.fromWhere == .feedDetail {
                                        self?.feedDetailViewWillAppearSubject?.onNext(())
                                    } else {
                                        self?.coordinator?.presenter.tabBarController?.selectedIndex = 0
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

extension LoginPopupViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }

    private func appleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    //로그인 성공시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email

            if let authorizationCode = appleIDCredential.authorizationCode,
               let identityToken = appleIDCredential.identityToken,
               let authString = String(data: authorizationCode, encoding: .utf8),
               let tokenString = String(data: identityToken, encoding: .utf8) {
                print("authorizationCode: \(authorizationCode)")
                print("identityToken: \(identityToken)")
                print("authString: \(authString)")
                print("tokenString: \(tokenString)")

                APIClient.createLoginToken(provider: "APPLE", accessToken: tokenString) {
                    UserDataManager.sharedInstance.userID = $0.id
                    UserDataManager.sharedInstance.loginToken = $0.token
                    UserDataManager.sharedInstance.fromWhereLogin = "apple"

                    if $0.isNicknameNull {
                        if self.fromWhere == .mapBottomSheet {
                            let nicknamePopup = NickNamePopupViewController.instantiate()
                            nicknamePopup.viewControllerWhereComeFrom = .mapBottomSheet
                            self.present(nicknamePopup, animated: false, completion: nil)
                        } else {
                            self.dismiss(animated: false, completion: nil)
                            self.coordinator?.presentNickNamePopup()
                        }
                    } else {
                        self.dismiss(animated: true, completion: nil)
                        if self.fromWhere == .feedDetail {
                            self.feedDetailViewWillAppearSubject?.onNext(())
                        } else {
                            self.coordinator?.presenter.tabBarController?.selectedIndex = 0
                        }
                    }
                }
            }

            print("useridentifier: \(userIdentifier)")
            print("fullName: \(String(describing: fullName))")
            print("email: \(String(describing: email))")

        case let passwordCredential as ASPasswordCredential:
            let userName = passwordCredential.user
            let password = passwordCredential.password

            print("username: \(userName)")
            print("password: \(password)")

        default: break
        }
    }

    //로그인 실패시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("apple login error")
    }
}
