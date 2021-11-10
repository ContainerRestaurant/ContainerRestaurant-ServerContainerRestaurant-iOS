//
//  SearchingRestaurantPopupCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/23.
//

import UIKit
import RxSwift
import FittedSheets

class SearchingRestaurantPopupCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    
    var afterSearchingRestaurantSubject: PublishSubject<([RestaurantModel],Bool)>?
    
    init(presenter: UINavigationController, _ afterSearchingRestaurantSubject: PublishSubject<([RestaurantModel],Bool)>) {
        self.presenter = presenter
        self.childCoordinators = []
        self.afterSearchingRestaurantSubject = afterSearchingRestaurantSubject
    }
    
    func start() {
        let SearchingRestaurantPopup = SearchingRestaurantPopupViewController.instantiate()
        SearchingRestaurantPopup.coordinator = self
        SearchingRestaurantPopup.modalPresentationStyle = .overFullScreen
        if let afterSearchingRestaurantSubject = self.afterSearchingRestaurantSubject {
            SearchingRestaurantPopup.afterSearchingRestaurantSubject = afterSearchingRestaurantSubject
        }
        presenter.present(SearchingRestaurantPopup, animated: false, completion: nil)
    }
}

extension SearchingRestaurantPopupCoordinator {
    func noRestaurantNearby() {
        let noRestaurantNearby = NoRestaurantNearbyViewController.instantiate()
        noRestaurantNearby.searchingRestaurantCoordinator = self
        noRestaurantNearby.isHiddenFindNearestRestaurantButton = true

        let sheetViewController = SheetViewController(controller: noRestaurantNearby,
                                                      sizes: [.fixed(323)],
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

        presenter.present(sheetViewController, animated: true, completion: nil)
    }

    func presentCreationFeed() {
        APIClient.checkLogin(loginToken: UserDataManager.sharedInstance.loginToken) { [weak self] user in
            if user.id == 0 {
                self?.presentLogin()
            } else {
                if let presenter = self?.presenter {
                    let coordinator = CreationFeedCoordinator(presenter: presenter)
                    coordinator.delegate = self
                    self?.childCoordinators.append(coordinator)
                    coordinator.start()
                }
            }
        }
    }

    func presentLogin() {
        let coordinator = LoginPopupCoordinator(presenter: presenter)
        coordinator.delegate = self
        coordinator.isFromTapBar = true
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
