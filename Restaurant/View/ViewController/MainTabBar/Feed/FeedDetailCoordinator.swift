//
//  FeedDetailCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/14.
//

import UIKit

class FeedDetailCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    var feedID: Int?
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
        
        print("FeedDetailCoordinator init")
    }
    
    deinit {
        print("FeedDetailCoordinator Deinit")
    }
    
    func start() {
        guard let feedID = self.feedID else { return }
        
        APIClient.feedDetail(feedID: feedID) { [weak self] feedDetailData in
            if let feedDetailData = feedDetailData {
                var feedDetail = FeedDetailViewController.instantiate()
                feedDetail.coordinator = self
                feedDetail.bind(viewModel: FeedDetailViewModel(feedDetailData))
                feedDetail.hidesBottomBarWhenPushed = true
                
                self?.presenter.pushViewController(feedDetail, animated: true)
            }
        }
    }
}

extension FeedDetailCoordinator {
    func presentDeleteFeedPopup(feedID: String) {
        let coordinator = CommonPopupCoordinator(presenter: presenter, isTwoButton: true, buttonType: .deleteFeed)
        coordinator.delegate = self
        coordinator.feedID = feedID
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
