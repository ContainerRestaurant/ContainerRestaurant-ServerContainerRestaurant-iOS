//
//  LoginPopupCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/13.
//

import UIKit
import RxSwift

class LoginPopupCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }

    func start() {
        let login = LoginPopupViewController.instantiate()
        login.coordinator = self
        login.modalPresentationStyle = .overFullScreen
        self.presenter.present(login, animated: false, completion: nil)
    }
}

extension LoginPopupCoordinator {
    func presentNickNamePopup() {
        let coordinator = NickNamePopupCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
