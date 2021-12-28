//
//  ImageBannerPopupViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/10/16.
//

import UIKit

class ImageBannerPopupViewController: BaseViewController, Storyboard, UIScrollViewDelegate {
    weak var coordinator: ImageBannerPopupCoordinator?
    var imageURL: String?
    var image: UIImage?
    var imageView = UIImageView()

    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func clickedCloseButton(_ sender: Any) {
        coordinator?.presenter.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let imageURL = imageURL {
            let URL = URL(string: imageURL)
            imageView.kf.setImage(with: URL, options: [.transition(.fade(0.3))])
        }

        if let image = image {
            imageView.image = image
        }

        let screenWidth = UIScreen.main.bounds.width
        let imageHeight = (image?.size.height ?? 0).heightRatio()
        self.imageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: imageHeight)
        self.imageView.contentMode = .scaleAspectFill
        self.scrollView.addSubview(imageView)
        self.scrollView.contentSize = CGSize(width: screenWidth, height: imageHeight)
        self.scrollView.minimumZoomScale = 0.3
        self.scrollView.maximumZoomScale = 3.0
        self.scrollView.delegate = self
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }

    deinit {
        print("ImageBannerPopupViewController Deinit")
    }
}
