//
//  TestLoginViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/17.
//

import UIKit
import AuthenticationServices

@available(iOS 13.0, *)
class TestLoginViewController: BaseViewController {
    @IBOutlet weak var loginButton: UIButton!
    
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
    
    deinit {
        print("TestLoginViewController deinit")
    }
}

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
