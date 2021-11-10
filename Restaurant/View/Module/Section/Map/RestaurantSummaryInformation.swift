//
//  RestaurantSummaryInformation.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/31.
//

import UIKit
import Cosmos
import RxSwift

class RestaurantSummaryInformation: UICollectionViewCell {
    var restaurantID: Int?
    var latitude = 0.0
    var longitude = 0.0
    var mapReloadSubject: PublishSubject<([RestaurantModel],Bool)> = PublishSubject<([RestaurantModel],Bool)>()
    weak var coordinator: RestaurantSummaryInformationCoordinator?

    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var levelOfDifficultyView: CosmosView!
    @IBOutlet weak var levelOfDifficultyLabel: UILabel!
    @IBOutlet weak var feedCountButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBAction func clickedFavoriteButton(_ sender: Any) {
        guard let restaurantID = self.restaurantID else { return }

        APIClient.checkLogin(loginToken: UserDataManager.sharedInstance.loginToken) { [weak self] userModel in
            guard let self = self else { return }
            if userModel.id == 0 {
                self.coordinator?.presentLogin()
            } else {
                if self.favoriteButton.image(for: .normal) == UIImage(named: "favoriteDisabled20Px") {
                    APIClient.postFavoriteRestaurant(restaurantID: restaurantID) {
                        APIClient.nearbyRestaurants(latitude: self.latitude, longitude: self.longitude, radius: 2000) { [weak self] nearbyRestaurants in
                            self?.mapReloadSubject.onNext((nearbyRestaurants, true))
                        }
                    }
                    self.favoriteButton.setImage(UIImage(named: "favoriteFilled20Px"), for: .normal)
                    Common.hapticVibration()
                } else {
                    APIClient.deleteFavoriteRestaurant(restaurantID: restaurantID) {
                        APIClient.nearbyRestaurants(latitude: self.latitude, longitude: self.longitude, radius: 2000) { [weak self] nearbyRestaurants in
                            self?.mapReloadSubject.onNext((nearbyRestaurants, true))
                        }
                    }
                    self.favoriteButton.setImage(UIImage(named: "favoriteDisabled20Px"), for: .normal)
                    Common.hapticVibration()
                }
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(restaurant: RestaurantModel, latitude: Double, longitude: Double, mapReloadSubject: PublishSubject<([RestaurantModel],Bool)> = PublishSubject<([RestaurantModel],Bool)>(), coordinator: RestaurantSummaryInformationCoordinator) {
        self.restaurantID = restaurant.id
        self.latitude = latitude
        self.longitude = longitude
        self.mapReloadSubject = mapReloadSubject
        self.coordinator = coordinator

        restaurantNameLabel.text = restaurant.name
        favoriteButton.setImage(UIImage(named: restaurant.isFavorite ? "favoriteFilled20Px" : "favoriteDisabled20Px"), for: .normal)
        levelOfDifficultyView.rating = restaurant.difficultyAverage
        levelOfDifficultyLabel.text = String(restaurant.difficultyAverage)
        feedCountButton.setTitle(String(restaurant.feedCount), for: .normal)
    }
}
