//
//  LevelOfDifficultyAndWelcome.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/05.
//

import UIKit
import RxSwift
import Lottie

class LevelOfDifficultyAndWelcome: UICollectionViewCell {
    let disposeBag = DisposeBag()
    var levelOfDifficultySubject: PublishSubject<Int>?
    var isWelcome = false
    var isWelcomeSubject: PublishSubject<Bool>?
    let welcomeAnimationView = AnimationView(name: "welcome")

    @IBOutlet weak var levelOfDifficultyLabel: UIButton!
    @IBOutlet weak var levelOfDifficulty1: UIButton!
    @IBOutlet weak var levelOfDifficulty2: UIButton!
    @IBOutlet weak var levelOfDifficulty3: UIButton!
    @IBOutlet weak var levelOfDifficulty4: UIButton!
    @IBOutlet weak var levelOfDifficulty5: UIButton!
    @IBOutlet weak var welcomeButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        welcomeButton.applySketchShadow(color: .colorGrayGray08, alpha: 0.1, x: 0, y: 0, blur: 8, spread: 0)
        bindingView()
    }

    deinit {
        print("LevelOfDifficultyAndWelcome Deinit")
    }

    func configure(_ levelOfDifficultySubject: PublishSubject<Int>, _ isWelcomeSubject: PublishSubject<Bool>) {
        self.levelOfDifficultySubject = levelOfDifficultySubject
        self.isWelcomeSubject = isWelcomeSubject
    }
}

extension LevelOfDifficultyAndWelcome {
    private func bindingView() {
        levelOfDifficulty1.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.levelOfDifficultySubject?.onNext(1)
                owner.levelOfDifficultyLabel.setTitle("쉬워요", for: .normal)
                owner.buttonImage(index: 0)
            })
            .disposed(by: disposeBag)

        levelOfDifficulty2.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.levelOfDifficultySubject?.onNext(2)
                owner.levelOfDifficultyLabel.setTitle("할 만 해요", for: .normal)
                owner.buttonImage(index: 1)
            })
            .disposed(by: disposeBag)

        levelOfDifficulty3.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.levelOfDifficultySubject?.onNext(3)
                owner.levelOfDifficultyLabel.setTitle("보통이에요", for: .normal)
                owner.buttonImage(index: 2)
            })
            .disposed(by: disposeBag)

        levelOfDifficulty4.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.levelOfDifficultySubject?.onNext(4)
                owner.levelOfDifficultyLabel.setTitle("까다로워요", for: .normal)
                owner.buttonImage(index: 3)
            })
            .disposed(by: disposeBag)

        levelOfDifficulty5.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.levelOfDifficultySubject?.onNext(5)
                owner.levelOfDifficultyLabel.setTitle("많이 어려워요", for: .normal)
                owner.buttonImage(index: 4)
            })
            .disposed(by: disposeBag)

        welcomeButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.setWelcomeButton()
                Common.hapticVibration()
            })
            .disposed(by: disposeBag)
    }

    private func buttonImage(index: Int) {
        levelOfDifficulty2.setImage(UIImage(named: index >= 1 ? "hardFilled32Px" : "hardDisabled32Px"), for: .normal)
        levelOfDifficulty3.setImage(UIImage(named: index >= 2 ? "hardFilled32Px" : "hardDisabled32Px"), for: .normal)
        levelOfDifficulty4.setImage(UIImage(named: index >= 3 ? "hardFilled32Px" : "hardDisabled32Px"), for: .normal)
        levelOfDifficulty5.setImage(UIImage(named: index >= 4 ? "hardFilled32Px" : "hardDisabled32Px"), for: .normal)
    }

    private func setWelcomeButton() {
        isWelcome = !(isWelcome)
        isWelcomeSubject?.onNext(isWelcome)
        
        if isWelcome {
            welcomeButton.imageView?.addSubview(welcomeAnimationView)
            welcomeAnimationView.play()
        } else {
            welcomeButton.imageView?.subviews.forEach { $0.removeFromSuperview() }
        }
    }
}
