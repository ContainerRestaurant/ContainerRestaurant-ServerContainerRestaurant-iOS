//
//  MyDataCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/09/28.
//

import UIKit

class MyDataCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    var myDataType: MyDataType?

    init(presenter: UINavigationController, myDataType: MyDataType) {
        self.presenter = presenter
        self.myDataType = myDataType
        self.childCoordinators = []

        print("MyDataCoordinator init")
    }

    deinit {
        print("MyDataCoordinator Deinit")
    }

    func start() {
        switch self.myDataType {
        case .myFeed:
            APIClient.userFeed(userID: UserDataManager.sharedInstance.userID) { [weak self] feeds in
                var myFeedViewController = MyDataViewController.instantiate()
                myFeedViewController.coordinator = self
                myFeedViewController.myDataType = .myFeed
                myFeedViewController.bind(viewModel: MyDataViewModel(feeds: feeds))

                self?.presenter.pushViewController(myFeedViewController, animated: true)
            }
        case .scrapedFeed:
            APIClient.scrapedFeed(userID: UserDataManager.sharedInstance.userID) { [weak self] feeds in
                var myFeedViewController = MyDataViewController.instantiate()
                myFeedViewController.coordinator = self
                myFeedViewController.myDataType = .scrapedFeed
                myFeedViewController.bind(viewModel: MyDataViewModel(feeds: feeds))

                self?.presenter.pushViewController(myFeedViewController, animated: true)
            }
        case .favoriteRestaurant:
            APIClient.favoriteRestaurant() { [weak self] restaurants in
                var myFeedViewController = MyDataViewController.instantiate()
                myFeedViewController.coordinator = self
                myFeedViewController.myDataType = .favoriteRestaurant
                myFeedViewController.bind(viewModel: MyDataViewModel(restaurants: restaurants))

                self?.presenter.pushViewController(myFeedViewController, animated: true)
            }
        default: break
        }
    }
}

extension MyDataCoordinator {
    func presentLogin() {
        let coordinator = LoginPopupCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
