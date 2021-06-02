//
//  SearchRestaurantCoordinator.swift
//  Restaurant
//
//  Created by Lotte on 2021/06/01.
//

import UIKit
import RxSwift
import FittedSheets

class SearchRestaurantCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    var restaurantNameSubject: BehaviorSubject<String> = BehaviorSubject<String>(value: "")

    init(presenter: UINavigationController, subject: BehaviorSubject<String>) {
        self.presenter = presenter
        self.childCoordinators = []
        self.restaurantNameSubject = subject
    }

    func start() {
        setBottomSheetAndPresent()
    }
}

extension SearchRestaurantCoordinator {
    private func setBottomSheetAndPresent() {
        var searchRestaurant = SearchRestaurantViewController.instantiate()
        searchRestaurant.coordinator = self
        searchRestaurant.bind(viewModel: SearchRestaurantViewModel(restaurantNameSubject))

        let sheetViewController = SheetViewController(controller: searchRestaurant,
                                                      sizes: [.fixed(400)],
                                                      options: SheetOptions(
                                                        useFullScreenMode: false,
                                                        shrinkPresentingViewController: false))
        sheetViewController.allowPullingPastMaxHeight = false
        sheetViewController.dismissOnPull = true
        sheetViewController.cornerRadius = 24
        sheetViewController.gripColor = .colorGrayGray04
        sheetViewController.gripSize = CGSize(width: CGFloat(32).widthRatio(), height: 4)
        sheetViewController.didDismiss = { _ in
            print("sheetViewController didDismiss")
        }

        Common.currentViewController()?.present(sheetViewController, animated: true, completion: nil)
    }
}
