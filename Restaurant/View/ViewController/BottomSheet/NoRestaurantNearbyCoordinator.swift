//
//  NoRestaurantNearbyCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/23.
//

import UIKit
import RxSwift
import FittedSheets

class NoRestaurantNearbyCoordinator: Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    
    var afterSearchingRestaurantSubject: PublishSubject<([RestaurantModel],Bool)> = PublishSubject<([RestaurantModel],Bool)>()

    init(presenter: UINavigationController, _ afterSearchingRestaurantSubject: PublishSubject<([RestaurantModel],Bool)>) {
        self.presenter = presenter
        self.childCoordinators = []
        self.afterSearchingRestaurantSubject = afterSearchingRestaurantSubject
    }

    func start() {
        
    }
}

extension NoRestaurantNearbyCoordinator {
    func noRestaurantNearby() {
        let noRestaurantNearby = NoRestaurantNearbyViewController.instantiate()
        noRestaurantNearby.coordinator = self

        let sheetViewController = SheetViewController(controller: noRestaurantNearby,
                                                      sizes: [.fixed(387)],
                                                      options: SheetOptions(
                                                        pullBarHeight: 0,
                                                        useFullScreenMode: false,
                                                        shrinkPresentingViewController: false))
        sheetViewController.allowPullingPastMaxHeight = false
        sheetViewController.dismissOnPull = true
        sheetViewController.cornerRadius = 24
        sheetViewController.didDismiss = { _ in
            print("sheetViewController didDismiss")
        }

        Common.currentViewController()?.present(sheetViewController, animated: true, completion: nil)
    }
    
    func presentCreationFeed() {
        let coordinator = CreationFeedCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func presentSearchingRestaurantPopup() {
        let coordinator = SearchingRestaurantPopupCoordinator(presenter: presenter, afterSearchingRestaurantSubject)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
