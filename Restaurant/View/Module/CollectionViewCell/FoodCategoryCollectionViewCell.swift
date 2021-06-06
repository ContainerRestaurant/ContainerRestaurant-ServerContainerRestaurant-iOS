//
//  FoodCategoryCollectionViewCell.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/03.
//

import UIKit

class FoodCategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var foodCategoryButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(title: String, isClicked: Bool) {
        foodCategoryButton.setTitle(title, for: .normal)
        foodCategoryButton.borderColor = isClicked ? .colorMainGreen04 : .colorGrayGray04
        foodCategoryButton.setTitleColor(isClicked ? .colorMainGreen04 : .colorGrayGray06, for: .normal)
    }
}
