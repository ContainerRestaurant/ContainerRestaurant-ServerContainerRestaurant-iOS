//
//  SearchRestaurantCollectionViewCell.swift
//  Restaurant
//
//  Created by Lotte on 2021/06/01.
//

import UIKit

class SearchRestaurantCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantAdressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(_ restaurantName: String, restaurantAddress: String) {
        //Todo: rx로 바인딩
    }
}
