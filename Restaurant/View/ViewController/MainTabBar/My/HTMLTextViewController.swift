//
//  HTMLTextViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/09/16.
//

import UIKit

enum HTMLTextType {
    case privacyPolicy
    case serviceAccessTerms
    case none

    var title: String {
        switch self {
        case .privacyPolicy: return "개인정보 취급방침"
        case .serviceAccessTerms: return "서비스 이용약관"
        case .none: return ""
        }
    }
}

class HTMLTextViewController: BaseViewController, Storyboard {
    weak var coordinator: HTMLTextCoordinator?
    var htmlTextType: HTMLTextType = .none
    var contractInfo: ContractInfo?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        setTextView()

        print("HTMLTextViewController viewDidLoad()")
    }

    deinit {
        print("HTMLTextViewController Deinit")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setNavigation()
    }
}

extension HTMLTextViewController {
    private func setNavigation() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let backImage = UIImage(named: "chevronLeftOutline20Px")
        self.coordinator?.presenter.navigationBar.backIndicatorImage = backImage
        self.coordinator?.presenter.navigationBar.backIndicatorTransitionMaskImage = backImage

        self.coordinator?.presenter.navigationBar.isTranslucent = false
        self.coordinator?.presenter.navigationBar.tintColor = .colorGrayGray07
        self.coordinator?.presenter.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.colorGrayGray07]

        self.navigationItem.title = htmlTextType.title
    }

    private func setTextView() {
        let title = contractInfo?.title.htmlToAttributedString()
        let article = contractInfo?.article.htmlToAttributedString()

        self.titleLabel.attributedText = title
        self.textView.attributedText = article

        let sizeThatFitsTextView = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat(MAXFLOAT)))
        let heightOfText = sizeThatFitsTextView.height
        textViewHeight.constant = heightOfText
    }
}
