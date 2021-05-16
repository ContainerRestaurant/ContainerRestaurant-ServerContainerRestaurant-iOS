//
//  HomeCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/15.
//

import UIKit

class HomeCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
//    var viewController: HomeViewController?
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }
    
    func start() {
        let home = HomeViewController.instantiate()
        home.coordinator = self
//        self.viewController = home
        
        presenter.pushViewController(home, animated: true)
    }
    
    func presentToMyContainer() {
        let coordinator = CreationPopupCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func pushToContainerOfEveryone() {
        let coordinator = ContainerOfEveryoneCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
