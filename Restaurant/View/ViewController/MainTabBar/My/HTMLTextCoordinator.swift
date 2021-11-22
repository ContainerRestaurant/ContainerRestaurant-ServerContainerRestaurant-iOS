//
//  HTMLTextCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/09/16.
//

import UIKit

class HTMLTextCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    var htmlTextType: HTMLTextType = .none

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []

        print("HTMLTextCoordinator init")
    }

    deinit {
        print("HTMLTextCoordinator Deinit")
    }

    func start() {
        APIClient.fetchContract { [weak self] contractInfo in
            guard let self = self else { return }
            let htmlTextViewController = HTMLTextViewController.instantiate()
            htmlTextViewController.coordinator = self
            htmlTextViewController.htmlTextType = self.htmlTextType
            htmlTextViewController.contractInfo = contractInfo[self.htmlTextType == .privacyPolicy ? 0 : 1]

            self.presenter.pushViewController(htmlTextViewController, animated: true)
        }
    }
}
