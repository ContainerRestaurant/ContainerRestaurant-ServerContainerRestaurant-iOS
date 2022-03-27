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
    var isFromFeedDetail: Bool = false
    var imageURL: String?
    var image: UIImage?

    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
    }

    func start() {
        let imageBannerPopup = ImageBannerPopupViewController.instantiate()
        imageBannerPopup.coordinator = self
        imageBannerPopup.modalPresentationStyle = .overFullScreen
        if let imageURL = imageURL {
            imageBannerPopup.imageURL = imageURL
        }
        if let image = image {
            imageBannerPopup.image = image
        }
        imageBannerPopup.isFromFeedDetail = isFromFeedDetail
        
        presenter.present(imageBannerPopup, animated: true, completion: nil)
    }
}
