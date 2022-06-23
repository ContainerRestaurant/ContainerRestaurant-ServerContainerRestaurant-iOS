//
//  CreationFeedDetailCardCollectionViewCell.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/29.
//

import UIKit

class CreationFeedDetailCardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var mainTextField: UITextField!
    @IBOutlet weak var subTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setTextField()
        self.mainView.applySketchShadow(color: .colorGrayGray08, alpha: 0.1, x: 0, y: 0, blur: 8, spread: 0)
    }

    func configure(foodType: FoodType) {
        mainTitleLabel.text = "음식"
        subTitleLabel.text = "용기"

        mainTextField.placeholder = foodType == .main ? "ex) 된장국" : "ex) 단무지, 멸치볶음"
        subTextField.placeholder = foodType == .main ? "ex) 500ml 반찬통" : "ex) 3칸 칸막이 1개"
    }
}

extension CreationFeedDetailCardCollectionViewCell {
    func setTextField() {
        self.mainTextField.font = .systemFont(ofSize: 14)
        self.subTextField.font = .systemFont(ofSize: 14)
        self.mainTextField.textColor = .colorGrayGray06
        self.subTextField.textColor = .colorGrayGray06
    }
}
