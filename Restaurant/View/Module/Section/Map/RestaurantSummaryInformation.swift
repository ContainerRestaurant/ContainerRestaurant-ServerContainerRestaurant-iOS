//
//  RestaurantSummaryInformation.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/31.
//

import UIKit
import Cosmos

class RestaurantSummaryInformation: UICollectionViewCell {
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var levelOfDifficultyView: CosmosView!
    @IBOutlet weak var levelOfDifficultyLabel: UILabel!
    @IBOutlet weak var feedCountButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(restaurant: RestaurantModel) {
        restaurantNameLabel.text = restaurant.name
        levelOfDifficultyView.rating = restaurant.difficultyAverage
        levelOfDifficultyLabel.text = String(restaurant.difficultyAverage)
        feedCountButton.setTitle(String(restaurant.feedCount), for: .normal)
    }
}
