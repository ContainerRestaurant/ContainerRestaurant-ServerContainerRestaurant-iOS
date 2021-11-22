//
//  ImageBannerPopupCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/10/16.
//

import UIKit

class ImageBannerPopupCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    var imageURL: String?

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }

    func start() {
        let imageBannerPopup = ImageBannerPopupViewController.instantiate()
        imageBannerPopup.coordinator = self
        imageBannerPopup.modalPresentationStyle = .fullScreen
        imageBannerPopup.imageURL = imageURL
        
        presenter.present(imageBannerPopup, animated: true, completion: nil)
    }
}
