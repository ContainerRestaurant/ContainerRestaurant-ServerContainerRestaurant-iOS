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
    var viewTranslation = CGPoint(x: 0, y: 0)
    var viewVelocity = CGPoint(x: 0, y: 0)

    @IBOutlet weak var scrollView: UIScrollView!
    @IBAction func clickedCloseButton(_ sender: Any) {
        coordinator?.presenter.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setImageInScrollView()
    }

    deinit {
        print("ImageBannerPopupViewController Deinit")
    }

    private func setImageInScrollView() {
        var imageHeight: CGFloat = 0

        if let imageURL = imageURL {
            let URL = URL(string: imageURL)
            imageView.kf.setImage(with: URL, options: [.transition(.fade(0.3))])

            if let imageSource = CGImageSourceCreateWithURL(URL! as CFURL, nil) {
                if let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary? {
                    let pixelHeight: CGFloat = imageProperties[kCGImagePropertyPixelHeight] as! CGFloat
                    let threeX: CGFloat = 3
                    imageHeight = pixelHeight/threeX
                }
            }
        }

        if let image = image {
            imageView.image = image
            imageHeight = image.size.height
        }

        let screenWidth = UIScreen.main.bounds.width
        self.imageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: imageHeight)
        self.imageView.contentMode = .scaleAspectFit
        self.scrollView.addSubview(imageView)
        self.scrollView.contentSize = CGSize(width: screenWidth, height: imageHeight)

        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 3.0

        self.scrollView.delegate = self
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = CGFloat(0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
}
