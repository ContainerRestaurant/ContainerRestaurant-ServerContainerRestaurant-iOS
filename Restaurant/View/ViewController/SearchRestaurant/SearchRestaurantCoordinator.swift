//
//  SearchRestaurantCoordinator.swift
//  Restaurant
//
//  Created by Lotte on 2021/06/01.
//

//지워도 될 것 같음 나중에 삭제 => 코디네이터로 띄우는 형태가 아니라서.
import UIKit

class SearchRestaurantCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }

    func start() {
        let searchRestaurant = SearchRestaurantViewController.instantiate()
        searchRestaurant.coordinator = self
        presenter.present(searchRestaurant, animated: true, completion: nil)
    }
}

extension CreationCoordinator {

}
