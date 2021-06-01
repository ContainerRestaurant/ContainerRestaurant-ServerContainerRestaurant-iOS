//
//  ListStandardDescriptionPopupViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/12.
//

import UIKit

class ListStandardDescriptionPopupViewController: BaseViewController, Storyboard {
    weak var coordinator: ListStandardDescriptionPopupCoordinator?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionText()
        okButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    func descriptionText() {
        let attributedString = NSMutableAttributedString(string: "우주같이 웅장한 용기를 가진 분은\n최근 30일간 피드를 가장 많이 작성한 순\n으로 보여지며, 매일 1회 업데이트 됩니다.\n\n세상을 바꾸는 특별한 용기를 가진 분들은\n가장 최근 피드를 작성한 순으로 보여지며,\n실시간으로 업데이트 됩니다.", attributes: [
          .font: UIFont(name: "AppleSDGothicNeo-Regular", size: 14.0)!,
            .foregroundColor: UIColor.colorGrayGray06
        ])
        attributedString.addAttribute(.font, value: UIFont(name: "AppleSDGothicNeo-Bold", size: 14.0)!, range: NSRange(location: 19, length: 24))
        attributedString.addAttribute(.font, value: UIFont(name: "AppleSDGothicNeo-Bold", size: 14.0)!, range: NSRange(location: 92, length: 15))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        descriptionLabel.attributedText = attributedString
        descriptionLabel.textAlignment = .center
    }
    
    deinit {
        print("ListStandardDescriptionPopupViewController Deinit")
    }
}
