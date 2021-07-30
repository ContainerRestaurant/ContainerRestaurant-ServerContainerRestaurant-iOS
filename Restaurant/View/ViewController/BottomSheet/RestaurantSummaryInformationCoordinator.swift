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
        let restaurantSummaryInformation = RestaurantSummaryInformationViewController.instantiate()
        restaurantSummaryInformation.coordinator = self
        restaurantSummaryInformation.restaurant = self.restaurant
        var bottomSheetHeight: CGFloat = 168
        if Common.isNotchPhone { bottomSheetHeight += Common.homeBarHeight }

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
        sheetViewController.didDismiss = { _ in
            print("sheetViewController didDismiss")
        }

        Common.currentViewController()?.present(sheetViewController, animated: true, completion: nil)
    }
}
