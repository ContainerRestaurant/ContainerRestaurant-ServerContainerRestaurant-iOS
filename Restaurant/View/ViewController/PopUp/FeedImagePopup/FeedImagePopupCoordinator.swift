//
//  FeedImagePopupCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2022/03/27.
//

import UIKit

class FeedImagePopupCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    var image: UIImage?

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }

    func start() {
        let feedImagePopup = FeedImagePopupViewController.instantiate()
        feedImagePopup.coordinator = self
        feedImagePopup.modalPresentationStyle = .overFullScreen
        if let image = image {
            feedImagePopup.image = image
        }

        presenter.present(feedImagePopup, animated: true, completion: nil)
    }
}
