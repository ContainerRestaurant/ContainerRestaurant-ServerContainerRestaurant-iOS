//
//  ContainerOfEveryoneCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/16.
//

import UIKit
import RxSwift

class ContainerOfEveryoneCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    let disposeBag = DisposeBag()
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }
    
    func start() {
        APIClient.containerOfEveryone { [weak self] containerOfEveryoneData in
            var containerOfEveryone = ContainerOfEveryoneViewController.instantiate()
            containerOfEveryone.coordinator = self
            containerOfEveryone.bind(viewModel: ContainerOfEveryoneViewModel(containerOfEveryoneData))
            containerOfEveryone.hidesBottomBarWhenPushed = true

            self?.presenter.pushViewController(containerOfEveryone, animated: true)
        }
    }
    
    func presentToListStandardDescription() {
        let coordinator = ListStandardDescriptionPopupCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func pushToInquiryProfile(userID: Int) {
        let coordinator = InquiryProfileCoordinator(presenter: presenter, userID: userID)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
