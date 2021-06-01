//
//  ContainerOfEveryoneCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/16.
//

import UIKit

class ContainerOfEveryoneCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }
    
    func start() {
        let containerOfEveryone = ContainerOfEveryoneViewController.instantiate()
        containerOfEveryone.coordinator = self
        presenter.pushViewController(containerOfEveryone, animated: true)
    }
    
    func presentToListStandardDescription() {
        let coordinator = ListStandardDescriptionPopupCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func pushToInquiryProfile() {
        let coordinator = InquiryProfileCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
