//
//  TestLoginViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/17.
//

import UIKit
import AuthenticationServices
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

@available(iOS 13.0, *)
class TestLoginViewController: BaseViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var kakaoLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton()
    }
    
    func addButton() {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
        button.addTarget(self, action: #selector(handleAppleSignInButton), for: .touchUpInside)
        loginButton.addSubview(button)
    }
    
    @objc func handleAppleSignInButton() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self as? ASAuthorizationControllerDelegate
        controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
        controller.performRequests()
    }
    
    @IBAction func kakaoLogin(_ sender: Any) {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk {(oAuthToken, error) in
                if let error = error {
                    print("로그인 여부\(error)")
                } else {
                    print("loginWithKakaoTalk() success.")
                    
                    //do something
                    _ = oAuthToken
                    
                    UserApi.shared.me() { (user, error) in
                        if let error = error {
                            print("사용자 정보 가져오기 \(error)")
                        } else {
                            print("me() success.")
                            
                            //do something
                            print("User(id): \(user?.id)")
                            print("kakaoAcount: \(user?.kakaoAccount)")
                            print("User Properties: \(user?.properties)")
                        }
                    }
                }
            }
        }
    }
    @IBAction func kakaoLogout(_ sender: Any) {
//        UserApi.shared.logout { (error) in
//            if let error = error {
//                print("로그아웃 \(error)")
//            } else {
//                print("logout() success.")
//            }
//        }
        
        UserApi.shared.unlink { (error) in
            if let error = error {
                print("연결 끊기 \(error)")
            } else {
                print("unlink() success")
            }
        }
        //TODO : logout & unlink & Token 간의 관계 연구 필요
        //https://developers.kakao.com/docs/latest/ko/kakaologin/ios#setting-for-kakaotalk
    }
    
    deinit {
        print("TestLoginViewController deinit")
    }
}

//애플 로그인
extension TestLoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let user = credential.user
            let fullName = credential.fullName
            let email = credential.email
            print("User: \(user)")
            print("fullName: \(fullName)")
            print("Email: \(email)")
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("fail")
    }
}
