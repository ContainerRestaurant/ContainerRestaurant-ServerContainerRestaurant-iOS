//
//  ImageBannerPopupViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/10/16.
//

import UIKit

class ImageBannerPopupViewController: BaseViewController, Storyboard, UIScrollViewDelegate {
    weak var coordinator: ImageBannerPopupCoordinator?
    var isFromFeedDetail: Bool?
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

        setImageScrollView()
        modalDismiss()
    }

    deinit {
        print("ImageBannerPopupViewController Deinit")
    }

    private func setImageScrollView() {
        guard let isFromFeedDetail = isFromFeedDetail else { return }
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
        let generalImageHeight = imageHeight
        let feedImageHeight = CGFloat(365).heightRatio()
        let topSpacing = CGFloat(74).heightRatio()
        let feedImageY = (scrollView.frame.height * 0.5) - (feedImageHeight * 0.5) - topSpacing
        let imageY = isFromFeedDetail ? feedImageY : 0
        let imageViewHeight = isFromFeedDetail ? feedImageHeight : generalImageHeight

        self.imageView.frame = CGRect(x: 0, y: imageY, width: screenWidth, height: imageViewHeight)
        self.imageView.contentMode = .scaleAspectFit
        self.scrollView.addSubview(imageView)
        self.scrollView.contentSize = CGSize(width: screenWidth, height: imageViewHeight)

        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 3.0

        self.scrollView.delegate = self
    }

    func modalDismiss() {
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismiss)))
    }

    @objc func handleDismiss(_ sender: UIPanGestureRecognizer) {
        viewTranslation = sender.translation(in: view)
        viewVelocity = sender.velocity(in: view)

        switch sender.state {
        case .changed:
            //위로 스와이프 안되도록 설정
            if viewVelocity.y > 0 {
                UIView.animate(withDuration: 0.1, animations: { [weak self] in
                    self?.view.transform = CGAffineTransform(translationX: 0, y: self?.viewTranslation.y ?? 0)
                })
            }
        case .ended:
            if viewTranslation.y < 200 {
                //원상 복구
                UIView.animate(withDuration: 0.1, animations: { [weak self] in
                    self?.view.transform = .identity
                })
            } else {
                dismiss(animated: true, completion: nil)
            }
        default: break
        }
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
