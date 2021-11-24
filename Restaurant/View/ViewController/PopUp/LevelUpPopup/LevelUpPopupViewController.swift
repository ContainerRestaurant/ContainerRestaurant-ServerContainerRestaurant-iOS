//
//  LevelUpPopupViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/11/21.
//

import UIKit
import Lottie

class LevelUpPopupViewController: BaseViewController, Storyboard {
    weak var coordinator: LevelUpPopupCoordinator?
    var levelUp: LevelUpModel?
    var okAction: (() -> Void)?

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lottieView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func okButton(_ sender: Any) {
        okAction?()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = Common.getLevelUpImage(levelUp?.to ?? "")
        setDescriptionLabel()
        setLottie()
        Common.hapticVibration()
    }

    private func setDescriptionLabel() {
        var toText: String {
            switch levelUp?.to {
            case "LV1. 텀블러": return "가"
            case "LV2. 밥그릇": return "이"
            case "LV3. 용기 세트": return "가"
            case "LV4. 후라이팬": return "이"
            case "LV5. 냄비": return "가"
            default: return ""
            }
        }

        let attributedString = NSMutableAttributedString()
            .bold(string: "\(levelUp?.levelFeedCount ?? 0)번째 ", fontColor: .colorGrayGray06, fontSize: 14)
            .regular(string: "피드를 작성하여\n", fontColor: .colorGrayGray06, fontSize: 14)
            .bold(string: levelUp?.from.components(separatedBy: ". ")[1] ?? "", fontColor: .colorGrayGray06, fontSize: 14)
            .regular(string: "에서 ", fontColor: .colorGrayGray06, fontSize: 14)
            .bold(string: levelUp?.to.components(separatedBy: ". ")[1] ?? "", fontColor: .colorGrayGray06, fontSize: 14)
            .regular(string: "\(toText) 되었어요!", fontColor: .colorGrayGray06, fontSize: 14)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.paragraphSpacing = 4
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))

        descriptionLabel.attributedText = attributedString
    }

    private func setLottie() {
        let animationView = AnimationView(name: "Levelup_congratulations")
        lottieView.addSubview(animationView)
        animationView.frame = CGRect(origin: lottieView.frame.origin, size: lottieView.frame.size)
        animationView.contentMode = .scaleAspectFit
        animationView.play()
    }

    deinit {
        print("LevelUpPopupViewController Deinit")
    }
}
