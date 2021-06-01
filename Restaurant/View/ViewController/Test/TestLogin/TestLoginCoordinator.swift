//
//  TestLoginCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/26.
//

import UIKit

class TestLoginCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }

    func start() {
        let my = TestLoginViewController.instantiate()
        my.coordinator = self
        presenter.pushViewController(my, animated: true)
    }

    deinit {
        print("TestLoginCoordinator Deinit")
    }
}
