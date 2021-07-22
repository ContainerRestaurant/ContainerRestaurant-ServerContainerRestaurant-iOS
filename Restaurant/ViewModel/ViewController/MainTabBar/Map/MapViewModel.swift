//
//  MapViewModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/21.
//

import Foundation
import NMapsMap
import RxSwift

class MapViewModel {
    var isFirstEntry = true
    var nearbyRestaurants: [RestaurantModel] = []
    var latitude: Double = 0
    var longitude: Double = 0
    var nearbyRestaurantsFlag: PublishSubject<Void> = PublishSubject<Void>()
    
    
    init() {
        
    }
    
    //일단 식당 나오게 임시로 radius 2000 => default 뭔지 안드랑 기획에 여쭤보기
    func fetchNearbyRestaurants() {
        APIClient.nearbyRestaurants(latitude: latitude, longitude: longitude, radius: 2000) { [weak self] nearbyRestaurants in
            self?.nearbyRestaurants = nearbyRestaurants
            self?.nearbyRestaurantsFlag.onNext(())
        }
    }
}
