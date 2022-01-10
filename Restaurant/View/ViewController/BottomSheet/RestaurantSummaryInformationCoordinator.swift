//
//  RestaurantSummaryInformationCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/27.
//

import UIKit
import FittedSheets
import RxSwift

class RestaurantSummaryInformationCoordinator: Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]

    var restaurant: RestaurantModel?
    var latitude: Double?
    var longitude: Double?
    var afterSearchingRestaurantSubject: PublishSubject<([RestaurantModel],Bool)>?
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []

        print("RestaurantSummaryInformationCoordinator init")
    }

    deinit {
        print("RestaurantSummaryInformationCoordinator Deinit 안탈거임")
    }

    func start() {
        APIClient.restaurantFeed(restaurantID: self.restaurant?.id ?? 0) { [weak self] restaurantFeed in
            var restaurantSummaryInformation = RestaurantSummaryInformationViewController.instantiate()
            restaurantSummaryInformation.coordinator = self
            restaurantSummaryInformation.bind(viewModel: RestaurantSummaryInformationViewModel(self?.restaurant ?? RestaurantModel(), restaurantFeed, self?.latitude ?? 0.0, self?.longitude ?? 0.0, self?.afterSearchingRestaurantSubject ?? PublishSubject<([RestaurantModel],Bool)>()))
            var bottomSheetHeight: CGFloat = 154
            if !(self?.restaurant?.isContainerFriendly ?? false) { bottomSheetHeight -= 31 }
            if UIDevice.current.hasNotch { bottomSheetHeight += Common.homeBarHeight }

            let sheetViewController = SheetViewController(controller: restaurantSummaryInformation,
                                                          sizes: [.fixed(bottomSheetHeight), .marginFromTop(44)],
                                                          options: SheetOptions(
                                                            pullBarHeight: 27,
                                                            useFullScreenMode: false,
                                                            shrinkPresentingViewController: false))
            sheetViewController.allowPullingPastMaxHeight = false
            sheetViewController.dismissOnPull = true
            sheetViewController.cornerRadius = 10
            sheetViewController.gripColor = .colorGrayGray03
            sheetViewController.handleScrollView(restaurantSummaryInformation.collectionView)
            sheetViewController.didDismiss = { _ in
                print("sheetViewController didDismiss")
            }

            Common.currentViewController()?.present(sheetViewController, animated: true, completion: nil)
        }
    }
}

extension RestaurantSummaryInformationCoordinator {
    func presentLogin() {
//        let coordinator = LoginPopupCoordinator(presenter: presenter)
//        coordinator.delegate = self
//        childCoordinators.append(coordinator)
//        coordinator.start()
        let loginPopup = LoginPopupViewController.instantiate()
        loginPopup.fromWhere = .mapBottomSheet
        Common.currentViewController()?.present(loginPopup, animated: false, completion: nil)
    }

    func pushToFeedDetail(feedID: Int, cell: TwoFeedCollectionViewCell) {
        let coordinator = FeedDetailCoordinator(presenter: presenter)
        coordinator.feedID = feedID
        coordinator.delegate = self
        coordinator.selectedCell = cell
        coordinator.isHiddenNavigationBarBeforePush = false
        childCoordinators.append(coordinator)
        coordinator.startTest()
    }
}
