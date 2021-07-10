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

    let recommendFeedSubject: PublishSubject<[FeedPreviewModel]> = PublishSubject<[FeedPreviewModel]>()
    let mainBannerSubject: PublishSubject<[BannerInfoModel]> = PublishSubject<[BannerInfoModel]>()
    let disposeBag = DisposeBag()
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }
    
    func start() {
        APIClient.mainBanner { [weak self] in self?.mainBannerSubject.onNext($0) }
        APIClient.recommendFeed { [weak self] in self?.recommendFeedSubject.onNext($0) }

        Observable.zip(self.mainBannerSubject, self.recommendFeedSubject)
            .subscribe(onNext: { [weak self] (mainBanner, recommendFeeds) in
                var homeViewController = HomeViewController.instantiate()
                homeViewController.coordinator = self
                homeViewController.bind(viewModel: HomeViewModel(recommendFeeds, mainBanner))

                self?.presenter.pushViewController(homeViewController, animated: false)
            })
            .disposed(by: disposeBag)
    }
}

extension HomeCoordinator {
    func presentCreationPopup() {
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
