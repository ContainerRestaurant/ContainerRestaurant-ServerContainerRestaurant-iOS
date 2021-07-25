//
//  SearchingRestaurantPopupCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/23.
//

import UIKit
import RxSwift

class SearchingRestaurantPopupCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    
    var afterSearchingRestaurantSubject: PublishSubject<[RestaurantModel]>?
    
    init(presenter: UINavigationController, _ afterSearchingRestaurantSubject: PublishSubject<[RestaurantModel]>) {
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


