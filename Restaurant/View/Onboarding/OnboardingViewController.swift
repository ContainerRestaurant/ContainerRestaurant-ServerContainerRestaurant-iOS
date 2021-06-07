//
//  OnboardingViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/07.
//

import UIKit
import RxSwift
import Lottie

class OnboardingViewController: BaseViewController, Storyboard {
    weak var coordinator: OnboardingCoordinator?
    var onboardingViews: [OnboardingView] = []
    let animationView1 = AnimationView(name: "onboarding1")
    let animationView2 = AnimationView(name: "onboarding2")
    let animationView3 = AnimationView(name: "onboarding3")

    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextAndCloseButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        skipButton.underLineTitle("건너뛰기", .colorGrayGray05, .systemFont(ofSize: 14))
        scrollView.delegate = self
        onboardingViews = createOnboardingView()
        onboardingScrollView(onboardings: onboardingViews)
//        pageControl()
        bind()
    }

    private func bind() {
        nextAndCloseButton.rx.tap
            .subscribe(onNext: { [weak self] in
                switch (self?.scrollView.contentOffset.x)! / UIScreen.main.bounds.width {
                case 0: self?.scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width, y: 0), animated: true)
                case 1: self?.scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width*2, y: 0), animated: true)
                case 2: self?.scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width*3, y: 0), animated: true)
                default: self?.coordinator?.closeOnboarding()
                }
            })
            .disposed(by: disposeBag)

        skipButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.closeOnboarding()
            })
            .disposed(by: disposeBag)
    }

    deinit {
        print("OnboardingViewController Deinit")
    }
}

extension OnboardingViewController {
    func createOnboardingView() -> [OnboardingView] {
        let onboarding1: OnboardingView = Bundle.main.loadNibNamed("OnboardingView", owner: self, options: nil)?.first as! OnboardingView
        onboarding1.mainTitleLabel.text = LongText.onboarding1MainTitle.rawValue
        onboarding1.subTitleLabel.text = LongText.onboarding1SubTitle.rawValue
        onboarding1.addSubview(animationView1)

        let animationView1Point = CGPoint(x: onboarding1.lottieView.frame.minX, y: onboarding1.lottieView.frame.minY)
        let animationView1Size = CGSize(width: CGFloat(260).widthRatio(), height: CGFloat(295).heightRatio())
        animationView1.frame = CGRect(origin: animationView1Point, size: animationView1Size)
        animationView1.contentMode = .scaleAspectFit
        animationView1.play()

        let onboarding2: OnboardingView = Bundle.main.loadNibNamed("OnboardingView", owner: self, options: nil)?.first as! OnboardingView
        onboarding2.mainTitleLabel.text = LongText.onboarding2MainTitle.rawValue
        onboarding2.subTitleLabel.text = LongText.onboarding2SubTitle.rawValue
        onboarding2.addSubview(animationView2)
        let animationView2Point = CGPoint(x: onboarding2.lottieView.frame.minX, y: onboarding2.lottieView.frame.minY)
        let animationView2Size = CGSize(width: CGFloat(260).widthRatio(), height: CGFloat(295).heightRatio())
        animationView2.frame = CGRect(origin: animationView2Point, size: animationView2Size)
        animationView2.contentMode = .scaleAspectFit

        let onboarding3: OnboardingView = Bundle.main.loadNibNamed("OnboardingView", owner: self, options: nil)?.first as! OnboardingView
        onboarding3.mainTitleLabel.text = LongText.onboarding3MainTitle.rawValue
        onboarding3.subTitleLabel.text = LongText.onboarding3SubTitle.rawValue
        onboarding3.addSubview(animationView3)
        let animationView3Point = CGPoint(x: onboarding3.lottieView.frame.minX, y: onboarding3.lottieView.frame.minY)
        let animationView3Size = CGSize(width: CGFloat(260).widthRatio(), height: CGFloat(295).heightRatio())
        animationView3.frame = CGRect(origin: animationView3Point, size: animationView3Size)
        animationView3.contentMode = .scaleAspectFit

        let onboarding4: OnboardingView = Bundle.main.loadNibNamed("OnboardingView", owner: self, options: nil)?.first as! OnboardingView
        onboarding4.mainTitleLabel.text = LongText.onboarding4MainTitle.rawValue
        onboarding4.subTitleLabel.text = LongText.onboarding4SubTitle.rawValue
        onboarding4.lottieView.backgroundColor = .green

        return [onboarding1, onboarding2, onboarding3, onboarding4]
    }

    private func onboardingScrollView(onboardings : [OnboardingView]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: CGFloat(480).heightRatio())
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(onboardings.count), height: CGFloat(480).heightRatio())
        scrollView.isPagingEnabled = true

        for i in 0 ..< onboardings.count {
            onboardings[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: scrollView.frame.height)
            scrollView.addSubview(onboardings[i])
        }
    }

    //    private func pageControl() {
    //        pageControl.numberOfPages = slides.count
    //        pageControl.currentPage = 0
    //        view.bringSubview(toFront: pageControl)
    //    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switch scrollView.contentOffset.x / UIScreen.main.bounds.width {
        case 0:
            nextAndCloseButton(title: "다음 단계", isHiddenSkipButton: false)
            animationView1.play()
        case 1:
            nextAndCloseButton(title: "다음 단계", isHiddenSkipButton: false)
            animationView2.play()
        case 2:
            nextAndCloseButton(title: "다음 단계", isHiddenSkipButton: false)
            animationView3.play()
        case 3: nextAndCloseButton(title: "시작하기", isHiddenSkipButton: true)
        default: nextAndCloseButton(title: "다음 단계", isHiddenSkipButton: false)
        }
    }

    private func nextAndCloseButton(title: String, isHiddenSkipButton: Bool) {
        skipButton.isHidden = isHiddenSkipButton
        UIView.performWithoutAnimation {
            nextAndCloseButton.setTitle(title, for: .normal)
            nextAndCloseButton.layoutIfNeeded()
        }
    }
}
