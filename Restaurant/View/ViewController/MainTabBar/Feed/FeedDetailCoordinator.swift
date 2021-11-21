//
//  FeedDetailCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/14.
//

import UIKit
import RxSwift

class FeedDetailCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    var feedID: Int?
    var feedDetailViewWillAppearSubject = PublishSubject<Void>()
    
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
                feedDetail.feedDetailViewWillAppearSubject = self?.feedDetailViewWillAppearSubject
                feedDetail.hidesBottomBarWhenPushed = true
                feedDetail.bind(viewModel: FeedDetailViewModel(feedDetailData))
                
                self?.presenter.pushViewController(feedDetail, animated: true)
            }
        }
    }
}

extension FeedDetailCoordinator {
    func presentLogin() {
        let coordinator = LoginPopupCoordinator(presenter: presenter)
        coordinator.delegate = self
        coordinator.feedDetailViewWillAppearSubject = self.feedDetailViewWillAppearSubject
        coordinator.fromWhere = .feedDetail
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func presentDeleteFeedPopup(feedID: String) {
        let coordinator = CommonPopupCoordinator(presenter: presenter, isTwoButton: true, buttonType: .deleteFeed)
        coordinator.delegate = self
        coordinator.feedID = feedID
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func presentDeleteCommentPopup(commentID: Int, reloadSubject: PublishSubject<Void>) {
        let coordinator = CommonPopupCoordinator(presenter: presenter, isTwoButton: true, buttonType: .deleteComment)
        coordinator.delegate = self
        coordinator.commentID = commentID
        coordinator.reloadSubject = reloadSubject
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func presentReportCommentPopup(commentID: Int) { //, reloadSubject: PublishSubject<Void>) {
        let coordinator = CommonPopupCoordinator(presenter: presenter, isTwoButton: true, buttonType: .reportComment)
        coordinator.delegate = self
        coordinator.commentID = commentID
//        coordinator.reloadSubject = reloadSubject
        childCoordinators.append(coordinator)
        coordinator.start()
    }

    func presentReportFeedPopup(feedID: String) {
        let coordinator = CommonPopupCoordinator(presenter: presenter, isTwoButton: true, buttonType: .reportFeed)
        coordinator.delegate = self
        coordinator.feedID = feedID
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
