//
//  CreationFeedCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/27.
//

import UIKit
import RxSwift

class CreationFeedCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }

    func start() {
        var creationFeed = CreationFeedViewController.instantiate()
        creationFeed.coordinator = self
        creationFeed.modalPresentationStyle = .fullScreen
        creationFeed.bind(viewModel: CreationFeedViewModel())
        presenter.present(creationFeed, animated: true, completion: nil)
    }
}

extension CreationFeedCoordinator {
    func presentBottomSheet(_ restaurantSubject: PublishSubject<LocalSearchItem>) {
        let coordinator = SearchRestaurantCoordinator(presenter: presenter, subject: restaurantSubject)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
