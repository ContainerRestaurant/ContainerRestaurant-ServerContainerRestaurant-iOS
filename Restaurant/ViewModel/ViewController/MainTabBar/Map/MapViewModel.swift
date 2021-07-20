//
//  MapViewModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/21.
//

import Foundation

class MapViewModel {
    var nearbyRestaurants: [RestaurantModel] = []
    
    init(_ nearbyRestaurants: [RestaurantModel]) {
        self.nearbyRestaurants = nearbyRestaurants
    }
}
