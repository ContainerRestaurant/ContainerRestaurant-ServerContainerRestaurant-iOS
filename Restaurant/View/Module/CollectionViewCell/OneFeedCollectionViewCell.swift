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
    
    func configure(_ restaurant: RestaurantModel) {
        let imageURL = URL(string: baseURL + restaurant.imagePath)
        feedImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.3))])
        restaurantNameLabel.text = restaurant.name
        levelOfDifficultyView.rating = restaurant.difficultyAverage
    }
}
