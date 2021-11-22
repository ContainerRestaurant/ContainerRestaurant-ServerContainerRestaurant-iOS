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
    let homeMainDataSubject: PublishSubject<HomeMainDataModel> = PublishSubject<HomeMainDataModel>()
    let disposeBag = DisposeBag()
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }
    
    func start() {
        APIClient.homeMainData { [weak self] in self?.homeMainDataSubject.onNext($0) }
        APIClient.recommendFeed { [weak self] in self?.recommendFeedSubject.onNext($0) }

        Observable.zip(self.homeMainDataSubject, self.recommendFeedSubject)
            .subscribe(onNext: { [weak self] (homeMainData, recommendFeeds) in
                var homeViewController = HomeViewController.instantiate()
                homeViewController.coordinator = self
                homeViewController.bind(viewModel: HomeViewModel(recommendFeeds, homeMainData))

                self?.presenter.view.layer.add(Common.pushFromTopTransition(), forKey: kCATransition)
                self?.presenter.pushViewController(homeViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension HomeCoordinator {
    func presentCreationPopup() {
        let coordinator = CommonPopupCoordinator(presenter: presenter, isTwoButton: true, buttonType: .creationFeed)
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

    func pushToInquiryProfile(userID: Int) {
        let coordinator = InquiryProfileCoordinator(presenter: presenter, userID: userID)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func pushToFeedDetail(feedID: Int) {
        let coordinator = FeedDetailCoordinator(presenter: presenter)
        coordinator.feedID = feedID
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func presentLogin() {
        let coordinator = LoginPopupCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func presentBannerPopup(imageURL: String) {
        let coordinator = ImageBannerPopupCoordinator(presenter: presenter)
        coordinator.delegate = self
        coordinator.imageURL = imageURL
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func presentWebViewPopup(webViewURL: String) {
        let coordinator = WebViewPopupCoordinator(presenter: presenter)
        coordinator.delegate = self
        coordinator.webViewURL = webViewURL
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
