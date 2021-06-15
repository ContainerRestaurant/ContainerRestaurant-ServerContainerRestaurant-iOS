//
//  NickNamePopupCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/15.
//

import UIKit
import RxSwift

class NickNamePopupCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }

    func start() {
        let nickName = NickNamePopupViewController.instantiate()
        nickName.coordinator = self
        nickName.modalPresentationStyle = .overFullScreen
        self.presenter.present(nickName, animated: false, completion: nil)
    }
}
