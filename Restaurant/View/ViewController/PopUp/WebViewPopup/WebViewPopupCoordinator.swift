//
//  WebViewPopupCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/11/22.
//

import UIKit

class WebViewPopupCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    var webViewURL: String?

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }

    func start() {
        let webViewPopup = WebViewPopupViewController.instantiate()
        webViewPopup.coordinator = self
        webViewPopup.modalPresentationStyle = .fullScreen
        webViewPopup.webViewURL = webViewURL

        presenter.present(webViewPopup, animated: true, completion: nil)
    }
}
