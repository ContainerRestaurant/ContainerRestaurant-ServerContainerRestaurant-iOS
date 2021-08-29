//
//  RestaurantSummaryInformationCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/27.
//

import UIKit
import FittedSheets

class RestaurantSummaryInformationCoordinator: Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]

    var restaurant: RestaurantModel?
    
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
            restaurantSummaryInformation.bind(viewModel: RestaurantSummaryInformationViewModel(self?.restaurant ?? RestaurantModel(), restaurantFeed))
            var bottomSheetHeight: CGFloat = 154
            if !(self?.restaurant?.isWelcome ?? false) { bottomSheetHeight -= 31 }
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
