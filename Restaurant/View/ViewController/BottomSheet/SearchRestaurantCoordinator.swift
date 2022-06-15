//
//  SearchRestaurantCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/01.
//

import UIKit
import RxSwift
import FittedSheets

final class SearchRestaurantCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    var restaurantSubject: PublishSubject<LocalSearchItem> = PublishSubject<LocalSearchItem>()

    init(presenter: UINavigationController, subject: PublishSubject<LocalSearchItem>) {
        self.presenter = presenter
        self.childCoordinators = []
        self.restaurantSubject = subject
    }

    func start() {
        setBottomSheetAndPresent()
    }
}

extension SearchRestaurantCoordinator {
    private func setBottomSheetAndPresent() {
        var searchRestaurant = SearchRestaurantViewController.instantiate()
        searchRestaurant.bind(viewModel: SearchRestaurantViewModel(restaurantSubject, self))

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
