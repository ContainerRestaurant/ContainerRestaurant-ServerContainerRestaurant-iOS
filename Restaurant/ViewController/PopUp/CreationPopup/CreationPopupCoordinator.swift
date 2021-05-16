//
//  CreationPopupCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/16.
//

import UIKit

class CreationPopupCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }
    
    func start() {
        let creationPopup = CreationPopupViewController.instantiate()
        creationPopup.coordinator = self
        creationPopup.modalPresentationStyle = .overFullScreen
        presenter.present(creationPopup, animated: false, completion: nil)
    }
}

