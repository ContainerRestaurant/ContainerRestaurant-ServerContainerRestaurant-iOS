//
//  ListStandardDescriptionPopupCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/16.
//

import UIKit

class ListStandardDescriptionPopupCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }
    
    func start() {
        let listStandardDescriptionPopup = ListStandardDescriptionPopupViewController.instantiate()
        listStandardDescriptionPopup.coordinator = self
        listStandardDescriptionPopup.modalPresentationStyle = .overFullScreen
        presenter.present(listStandardDescriptionPopup, animated: false, completion: nil)
    }
}

