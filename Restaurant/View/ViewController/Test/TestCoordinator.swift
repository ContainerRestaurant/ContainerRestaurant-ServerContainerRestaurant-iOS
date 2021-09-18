//
//  TestCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/26.
//

import UIKit

class TestCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }

    func start() {
        let test = TestViewController.instantiate()
        test.coordinator = self
        presenter.pushViewController(test, animated: false)
    }
}

extension TestCoordinator {
    func pushTestMap() {
        let coordinator = TestMapCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func pushTestLogin() {
        let coordinator = TestLoginCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func presentTestPopup() {
        let coordinator = CommonPopupCoordinator(presenter: presenter, isTwoButton: true, buttonType: .none)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
