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
        //Todo: ViewDidLoad 때에 데이터 못 가져올 수도 있어서 수정 필요
        var banner: [BannerInfo] = []
        APIClient.mainBanner { banner = $0 }
        //
        API().recommendFeed(subject: self.recommendFeedSubject)

        self.recommendFeedSubject.subscribe(onNext: { [weak self] in
            var home = HomeViewController.instantiate()
            home.coordinator = self
            home.bind(viewModel: HomeViewModel($0, banner))

            self?.presenter.pushViewController(home, animated: false)
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
