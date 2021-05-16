//
//  InquiryProfileCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/17.
//

import UIKit

class InquiryProfileCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }
    
    func start() {
        let inquiryProfile = InquiryProfileViewController.instantiate()
        inquiryProfile.coordinator = self
        presenter.pushViewController(inquiryProfile, animated: true)
    }
}
