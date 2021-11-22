//
//  NearbyRestaurantsViewModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/26.
//

import Foundation
import RxSwift

class NearbyRestaurantsViewModel {
    var nearbyRestaurants: [RestaurantModel] = []
    var latitudeInCenterOfMap: Double
    var longitudeInCenterOfMap: Double
    var afterSearchingRestaurantSubject: PublishSubject<([RestaurantModel],Bool)>
    
    init(nearbyRestaurants: [RestaurantModel], _ latitude: Double, _ longitude: Double, _ afterSearchingRestaurantSubject: PublishSubject<([RestaurantModel],Bool)>) {
        self.nearbyRestaurants = nearbyRestaurants
        self.latitudeInCenterOfMap = latitude
        self.longitudeInCenterOfMap = longitude
        self.afterSearchingRestaurantSubject = afterSearchingRestaurantSubject
    }
}
