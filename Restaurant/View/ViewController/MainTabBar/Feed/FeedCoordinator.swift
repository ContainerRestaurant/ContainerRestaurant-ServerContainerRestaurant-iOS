//
//  FeedCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/16.
//

import UIKit
import RxSwift

class FeedCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    let disposeBag = DisposeBag()
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
        
        print("FeedCoordinator init")
    }
    
    deinit {
        print("FeedCoordinator Deinit")
    }
    
    func start() {
        APIClient.feed(category: "ALL") { [weak self] (twoFeedModel) in
            var feed = FeedViewController.instantiate()
            feed.coordinator = self
            feed.bind(viewModel: FeedViewModel(twoFeedModel))

            self?.presenter.pushViewController(feed, animated: false)
        }
    }
}

extension FeedCoordinator {
    func pushToFeedDetail(feedID: Int) {
        let coordinator = FeedDetailCoordinator(presenter: presenter)
        coordinator.feedID = feedID
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func presentLogin() {
        let coordinator = LoginPopupCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
