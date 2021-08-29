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
    let mostFeedCreationUsersSubject = PublishSubject<[UserModel]>()
    let recentlyFeedCreationUsersSubject = PublishSubject<[UserModel]>()
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }
    
    func start() {
        APIClient.mostFeedCreationUsers { [weak self] in
            self?.mostFeedCreationUsersSubject.onNext($0)
        }

        APIClient.recentlyFeedCreationUsers { [weak self] in
            self?.recentlyFeedCreationUsersSubject.onNext($0)
        }

        Observable.zip(mostFeedCreationUsersSubject, recentlyFeedCreationUsersSubject)
            .subscribe(onNext: { [weak self] (mostFeedCreationUsers, recentlyFeedCreationUsers) in
                var containerOfEveryone = ContainerOfEveryoneViewController.instantiate()
                containerOfEveryone.coordinator = self
                containerOfEveryone.bind(viewModel: ContainerOfEveryoneViewModel(mostFeedCreationUsers, recentlyFeedCreationUsers))
                containerOfEveryone.hidesBottomBarWhenPushed = true

                self?.presenter.pushViewController(containerOfEveryone, animated: true)
            })
            .disposed(by: disposeBag)
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
