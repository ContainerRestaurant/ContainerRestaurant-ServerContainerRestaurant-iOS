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
    var userID = 0
    
    init(presenter: UINavigationController, userID: Int) {
        self.presenter = presenter
        self.userID = userID
        self.childCoordinators = []
    }
    
    func start() {
        APIClient.checkUser(userID: userID) { [weak self] userData in
            APIClient.userFeed(userID: userData.id) { [weak self] userFeed in
                let inquiryProfile = InquiryProfileViewController.instantiate()
                inquiryProfile.coordinator = self
                inquiryProfile.userData = userData
                inquiryProfile.userFeed = userFeed
                self?.presenter.pushViewController(inquiryProfile, animated: true)
            }
        }
    }
}
