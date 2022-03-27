//
//  FeedImagePopupViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2022/03/27.
//

import UIKit

class FeedImagePopupViewController: BaseViewController, Storyboard, UIScrollViewDelegate {
    weak var coordinator: FeedImagePopupCoordinator?
    var image: UIImage?
    var imageView = UIImageView()
    var viewTranslation = CGPoint(x: 0, y: 0)
    var viewVelocity = CGPoint(x: 0, y: 0)

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var closeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        bindingView()
        setImageInScrollView()
        modalDismiss()
    }

    deinit {
        print("FeedImagePopupViewController Deinit")
    }

    private func bindingView() {
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss()
            })
            .disposed(by: disposeBag)
    }

    private func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }

    private func setImageInScrollView() {
        if let image = image {
            imageView.image = image
        }

        let screenWidth = UIScreen.main.bounds.width
        let feedImageHeight = CGFloat(365).heightRatio()

        self.imageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: feedImageHeight)
        self.imageView.center = self.scrollView.center
        self.imageView.contentMode = .scaleAspectFit
        self.scrollView.addSubview(imageView)
        self.scrollView.contentSize = CGSize(width: screenWidth, height: feedImageHeight)

        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 3.0

        self.scrollView.delegate = self
    }

    private func modalDismiss() {
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
            if viewTranslation.y < 150 {
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
        let subView = scrollView.subviews[0]
        let offsetX = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0)
        let offsetY = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0)

        subView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
    }
}
