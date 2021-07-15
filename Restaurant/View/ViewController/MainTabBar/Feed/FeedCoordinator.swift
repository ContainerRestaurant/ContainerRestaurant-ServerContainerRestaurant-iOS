//
//  FeedCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/16.
//

import UIKit
import RxSwift

class FeedCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    
    let categoryFeedSubject: PublishSubject<[FeedPreviewModel]> = PublishSubject<[FeedPreviewModel]>()
    let disposeBag = DisposeBag()
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
        
        print("FeedCoordinator init")
    }
    
    deinit {
        print("FeedCoordinator Deinit")
    }
    
    func start() {
        APIClient.categoryFeed(category: "") { [weak self] in
            self?.categoryFeedSubject.onNext($0)
        }
        
        self.categoryFeedSubject
            .subscribe(onNext: { [weak self] categoryFeed in
                var feed = FeedViewController.instantiate()
                feed.coordinator = self
                feed.bind(viewModel: FeedViewModel(categoryFeed))
                
                self?.presenter.pushViewController(feed, animated: false)
            })
            .disposed(by: disposeBag)
    }
    
    func pushToFeedDetail(feedID: Int) {
        let coordinator = FeedDetailCoordinator(presenter: presenter)
        coordinator.feedID = feedID
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
