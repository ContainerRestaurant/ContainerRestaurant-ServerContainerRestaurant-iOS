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
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }

    func start() {
        let restaurantSummaryInformation = RestaurantSummaryInformationViewController.instantiate()
        restaurantSummaryInformation.coordinator = self

        let sheetViewController = SheetViewController(controller: restaurantSummaryInformation,
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
}
