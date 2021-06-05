//
//  HomeCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/15.
//

import UIKit
import RxSwift
import Alamofire

class HomeCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]

    let recommendFeedSubject: PublishSubject<RecommendFeed> = PublishSubject<RecommendFeed>()
    let disposeBag = DisposeBag()
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }
    
    func start() {
        API().recommendFeed(subject: self.recommendFeedSubject)

        self.recommendFeedSubject.subscribe(onNext: { [weak self] in
            var home = HomeViewController.instantiate()
            home.coordinator = self
            home.bind(viewModel: HomeViewModel(viewModel: $0))

            self?.presenter.pushViewController(home, animated: false)
        })
        .disposed(by: disposeBag)
    }
}

extension HomeCoordinator {
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
