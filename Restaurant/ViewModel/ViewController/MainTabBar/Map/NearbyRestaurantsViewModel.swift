//
//  NearbyRestaurantsViewModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/26.
//

import Foundation

class NearbyRestaurantsViewModel {
    var nearbyRestaurants: [RestaurantModel] = []
    
    init(nearbyRestaurants: [RestaurantModel]) {
        self.nearbyRestaurants = nearbyRestaurants
    }
}
