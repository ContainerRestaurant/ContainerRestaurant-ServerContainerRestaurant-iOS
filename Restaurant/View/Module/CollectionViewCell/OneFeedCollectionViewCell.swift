//
//  OneFeedCollectionViewCell.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/26.
//

import UIKit
import Cosmos
import RxSwift

class OneFeedCollectionViewCell: UICollectionViewCell {
    var restaurantID: Int?
    var latitude = 0.0
    var longitude = 0.0
    var mapReloadSubject: PublishSubject<([RestaurantModel],Bool)> = PublishSubject<([RestaurantModel],Bool)>()

    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var levelOfDifficultyView: CosmosView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var containerFriendlyImageView: UIImageView!
    @IBAction func clickedFavoriteButton(_ sender: Any) {
        if favoriteButton.image(for: .normal) == UIImage(named: "favoriteDisabled20Px") {
            guard let restaurantID = restaurantID else { return }
            APIClient.postFavoriteRestaurant(restaurantID: restaurantID) { [weak self] in
                guard let self = self else { return }
                APIClient.nearbyRestaurants(latitude: self.latitude, longitude: self.longitude, radius: 2000) { [weak self] nearbyRestaurants in
                    self?.mapReloadSubject.onNext((nearbyRestaurants, true))
                }
                Common.hapticVibration()
                self.favoriteButton.setImage(UIImage(named: "favoriteFilled20Px"), for: .normal)
            }
        } else {
            guard let restaurantID = restaurantID else { return }
            APIClient.deleteFavoriteRestaurant(restaurantID: restaurantID) { [weak self] in
                guard let self = self else { return }
                APIClient.nearbyRestaurants(latitude: self.latitude, longitude: self.longitude, radius: 2000) { [weak self] nearbyRestaurants in
                    self?.mapReloadSubject.onNext((nearbyRestaurants, true))
                }
                Common.hapticVibration()
                self.favoriteButton.setImage(UIImage(named: "favoriteDisabled20Px"), for: .normal)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(_ restaurant: RestaurantModel, _ latitude: Double, _ longitude: Double, _ afterSearchingRestaurantSubject: PublishSubject<([RestaurantModel],Bool)>) {
        self.restaurantID = restaurant.id
        self.longitude = longitude
        self.latitude = latitude
        self.mapReloadSubject = afterSearchingRestaurantSubject

        if !restaurant.imagePath.isEmpty {
            let imageURL = URL(string: restaurant.imagePath)
            feedImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.3))])
        }
        restaurantNameLabel.text = restaurant.name
        levelOfDifficultyView.rating = restaurant.difficultyAverage
        favoriteButton.setImage(UIImage(named: restaurant.isFavorite ? "favoriteFilled20Px" : "favoriteDisabled20Px"), for: .normal)
        containerFriendlyImageView.isHidden = !restaurant.isContainerFriendly
    }

    func favoriteRestaurantConfigure(_ restaurantFavoriteDto: RestaurantFavoriteDtoList) {
        let restaurant = restaurantFavoriteDto.restaurant
        self.restaurantID = restaurant.id

        if !restaurant.imagePath.isEmpty {
            let imageURL = URL(string: restaurant.imagePath)
            feedImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.3))])
        }
        restaurantNameLabel.text = restaurant.name
        levelOfDifficultyView.rating = restaurant.difficultyAverage
        favoriteButton.setImage(UIImage(named: restaurant.isFavorite ? "favoriteFilled20Px" : "favoriteDisabled20Px"), for: .normal)
        containerFriendlyImageView.isHidden = !restaurant.isContainerFriendly
    }
}
