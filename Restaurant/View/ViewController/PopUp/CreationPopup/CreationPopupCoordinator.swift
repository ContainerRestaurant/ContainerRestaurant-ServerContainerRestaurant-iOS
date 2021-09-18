//
//  CreationPopupCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/16.
//

import UIKit

class CreationPopupCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }
    
    func start() {
        let creationPopup = CommonPopupViewController.instantiate()
        creationPopup.coordinator = self
        creationPopup.modalPresentationStyle = .overFullScreen
        creationPopup.isTwoButton = true
        creationPopup.buttonType = .creationFeed

        presenter.present(creationPopup, animated: false, completion: nil)
    }
}

extension CreationPopupCoordinator {
    func presentLogin() {
        let coordinator = LoginPopupCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

