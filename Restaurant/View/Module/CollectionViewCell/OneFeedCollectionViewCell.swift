//
//  OneFeedCollectionViewCell.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/26.
//

import UIKit
import Cosmos

class OneFeedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var levelOfDifficultyView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(_ nearbyRestaurant: RestaurantModel) {
        let imageURL = URL(string: baseURL + nearbyRestaurant.imagePath)
        feedImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.3))])
        restaurantNameLabel.text = nearbyRestaurant.name
        levelOfDifficultyView.rating = nearbyRestaurant.difficultyAverage
    }
}
