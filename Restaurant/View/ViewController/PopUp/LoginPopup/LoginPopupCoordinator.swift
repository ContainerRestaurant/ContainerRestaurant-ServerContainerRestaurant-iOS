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
    var isFromTapBar = false
    var childCoordinators: [Coordinator]
    var fromWhere: loginPopupFromWhere = .none
    var feedDetailViewWillAppearSubject: PublishSubject<Void>?

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }

    deinit {
        print("LoginPopupCoordinator Deinit")
    }

    func start() {
        let login = LoginPopupViewController.instantiate()
        login.coordinator = self
        login.isFromTapBar = self.isFromTapBar
        login.fromWhere = self.fromWhere
        login.feedDetailViewWillAppearSubject = self.feedDetailViewWillAppearSubject
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
