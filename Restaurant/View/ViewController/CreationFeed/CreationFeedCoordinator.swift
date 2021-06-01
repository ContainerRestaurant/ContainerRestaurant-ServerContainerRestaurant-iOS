//
//  CreationFeedCoordinator.swift
//  Restaurant
//
//  Created by Lotte on 2021/05/27.
//

import UIKit

class CreationFeedCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }

    func start() {
        let creationFeed = CreationFeedViewController.instantiate()
        creationFeed.coordinator = self
//        creationFeed.modalPresentationStyle = .pageSheet
        creationFeed.viewModel = CreationFeedViewModel()
        presenter.present(creationFeed, animated: true, completion: nil)
    }
}

extension CreationFeedCoordinator {

}
