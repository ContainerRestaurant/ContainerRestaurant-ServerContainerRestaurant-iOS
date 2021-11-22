//
//  ImageBannerPopupViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/10/16.
//

import UIKit

class ImageBannerPopupViewController: BaseViewController, Storyboard {
    weak var coordinator: ImageBannerPopupCoordinator?
    var imageURL: String?

    @IBOutlet weak var imageView: UIImageView!
    @IBAction func clickedCloseButton(_ sender: Any) {
        coordinator?.presenter.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let URL = URL(string: imageURL ?? "")
        imageView.kf.setImage(with: URL, options: [.transition(.fade(0.3))])
    }

    deinit {
        print("ImageBannerPopupViewController Deinit")
    }
}
