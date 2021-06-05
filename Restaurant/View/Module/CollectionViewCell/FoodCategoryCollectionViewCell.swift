//
//  FoodCategoryCollectionViewCell.swift
//  Restaurant
//
//  Created by Lotte on 2021/06/03.
//

import UIKit

class FoodCategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var foodCategoryButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(title: String) {
        foodCategoryButton.setTitle(title, for: .normal)
    }
}
