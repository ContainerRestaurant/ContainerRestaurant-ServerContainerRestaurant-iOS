//
//  ImageBannerPopupViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/10/16.
//

import UIKit

class ImageBannerPopupViewController: BaseViewController, Storyboard {
    weak var coordinator: ImageBannerPopupCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    deinit {
        print("ImageBannerPopupViewController Deinit")
    }
}
