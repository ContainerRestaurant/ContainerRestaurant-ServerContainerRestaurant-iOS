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
    let animationView4 = AnimationView(name: "onboarding4")

    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var nextAndCloseButton: UIButton!
    @IBOutlet weak var pageControlView: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        skipButton.underLineTitle("건너뛰기", .colorGrayGray05, .systemFont(ofSize: 14))
        scrollView.delegate = self
        onboardingViews = createOnboardingView()
        onboardingScrollView(onboardings: onboardingViews)
        setIndicatorImage(page: 0)
        bindingView()
    }

    private func bindingView() {
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

//se 667
//8 : 667
//12mini : 812
//12promax 896
extension OnboardingViewController {
    func createOnboardingView() -> [OnboardingView] {
        //높이 330으로 세련님과 퉁
        let lottieHeight = UIDevice.current.hasNotch ? CGFloat(330).heightRatio() : CGFloat(295).heightRatio()

        let onboarding1: OnboardingView = Bundle.main.loadNibNamed("OnboardingView", owner: self, options: nil)?.first as! OnboardingView
        onboarding1.mainTitleLabel.text = LongText.onboarding1MainTitle.rawValue
        onboarding1.subTitleLabel.text = LongText.onboarding1SubTitle.rawValue
        onboarding1.addSubview(animationView1)
        let animationView1Point = CGPoint(x: onboarding1.lottieView.frame.minX, y: onboarding1.lottieView.frame.minY)
        let animationView1Size = CGSize(width: CGFloat(260).widthRatio(), height: lottieHeight)
        animationView1.frame = CGRect(origin: animationView1Point, size: animationView1Size)
        animationView1.contentMode = .scaleAspectFit
        animationView1.play()

        let onboarding2: OnboardingView = Bundle.main.loadNibNamed("OnboardingView", owner: self, options: nil)?.first as! OnboardingView
        onboarding2.mainTitleLabel.text = LongText.onboarding2MainTitle.rawValue
        onboarding2.subTitleLabel.text = LongText.onboarding2SubTitle.rawValue
        onboarding2.addSubview(animationView2)
        let animationView2Point = CGPoint(x: onboarding2.lottieView.frame.minX, y: onboarding2.lottieView.frame.minY)
        let animationView2Size = CGSize(width: CGFloat(260).widthRatio(), height: lottieHeight)
        animationView2.frame = CGRect(origin: animationView2Point, size: animationView2Size)
        animationView2.contentMode = .scaleAspectFit

        let onboarding3: OnboardingView = Bundle.main.loadNibNamed("OnboardingView", owner: self, options: nil)?.first as! OnboardingView
        onboarding3.mainTitleLabel.text = LongText.onboarding3MainTitle.rawValue
        onboarding3.subTitleLabel.text = LongText.onboarding3SubTitle.rawValue
        onboarding3.addSubview(animationView3)
        let animationView3Point = CGPoint(x: onboarding3.lottieView.frame.minX, y: onboarding3.lottieView.frame.minY)
        let animationView3Size = CGSize(width: CGFloat(260).widthRatio(), height: lottieHeight)
        animationView3.frame = CGRect(origin: animationView3Point, size: animationView3Size)
        animationView3.contentMode = .scaleAspectFit

        let onboarding4: OnboardingView = Bundle.main.loadNibNamed("OnboardingView", owner: self, options: nil)?.first as! OnboardingView
        onboarding4.mainTitleLabel.text = LongText.onboarding4MainTitle.rawValue
        onboarding4.subTitleLabel.text = LongText.onboarding4SubTitle.rawValue
        onboarding4.addSubview(animationView4)
        let animationView4Point = CGPoint(x: onboarding3.lottieView.frame.minX, y: onboarding4.lottieView.frame.minY)
        let animationView4Size = CGSize(width: CGFloat(260).widthRatio(), height: lottieHeight)
        animationView4.frame = CGRect(origin: animationView4Point, size: animationView4Size)
        animationView4.contentMode = .scaleAspectFit

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
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            scrollView.contentOffset.y = 0
        }
        
        switch scrollView.contentOffset.x / UIScreen.main.bounds.width {
        case 0:
            setIndicatorImage(page: 0)
            nextAndCloseButton(title: "다음 단계", isHiddenSkipButton: false)
            animationView1.play()
        case 1:
            setIndicatorImage(page: 1)
            nextAndCloseButton(title: "다음 단계", isHiddenSkipButton: false)
            animationView2.play()
        case 2:
            setIndicatorImage(page: 2)
            nextAndCloseButton(title: "다음 단계", isHiddenSkipButton: false)
            animationView3.play()
        case 3:
            setIndicatorImage(page: 3)
            nextAndCloseButton(title: "시작하기", isHiddenSkipButton: true)
            animationView4.play()
        default:
            break
        }
    }

    private func setIndicatorImage(page: Int) {
        pageControlView.currentPageIndicatorTintColor = .colorGrayGray04
        pageControlView.currentPage = page
        for i in 0...3 {
            if i == page {
                if #available(iOS 14.0, *) {
                    pageControlView.setIndicatorImage(UIImage(named: "selectedIndicatorIcon"), forPage: i)
                } else { }
            } else {
                if #available(iOS 14.0, *) {
                    pageControlView.setIndicatorImage(UIImage(named: "indicatorIcon"), forPage: i)
                } else { }
            }
        }
        pageControlView.currentPageIndicatorTintColor = .colorMainGreen02
    }

    private func nextAndCloseButton(title: String, isHiddenSkipButton: Bool) {
        skipButton.isHidden = isHiddenSkipButton
        UIView.performWithoutAnimation {
            nextAndCloseButton.setTitle(title, for: .normal)
            nextAndCloseButton.layoutIfNeeded()
        }
    }
}
