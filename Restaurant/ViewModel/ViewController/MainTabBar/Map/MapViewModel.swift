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
    var disposeBag = DisposeBag()
    var isFirstEntry = true
    var nearbyRestaurants: [RestaurantModel] = []
    var (myLatitude,latitudeInCenterOfMap): (Double,Double) = (0,0)
    var (myLongitude,longitudeInCeterOfMap): (Double,Double) = (0,0)
    var myNearbyRestaurantsFlag: PublishSubject<Bool> = PublishSubject<Bool>()
    var currentNearbyRestaurantsFlag: PublishSubject<Void> = PublishSubject<Void>()
    
    init(_ afterSearchingRestaurantSubject: PublishSubject<([RestaurantModel],Bool)>) {
        afterSearchingRestaurantSubject.subscribe(onNext: { [weak self] (nearbyRestaurants, isFavoriteAction) in
            self?.nearbyRestaurants = nearbyRestaurants
            self?.myNearbyRestaurantsFlag.onNext(isFavoriteAction)
        })
        .disposed(by: disposeBag)
    }
    
    func fetchMyNearbyRestaurants() {
        APIClient.nearbyRestaurants(latitude: myLatitude, longitude: myLongitude, radius: 2000) { [weak self] nearbyRestaurants in
            self?.nearbyRestaurants = nearbyRestaurants
            self?.myNearbyRestaurantsFlag.onNext(false)
        }
    }

    func fetchCurrentNearbyRestaurants() {
        APIClient.nearbyRestaurants(latitude: latitudeInCenterOfMap, longitude: longitudeInCeterOfMap, radius: 2000) { [weak self] nearbyRestaurants in
            self?.nearbyRestaurants = nearbyRestaurants
            self?.currentNearbyRestaurantsFlag.onNext(())
        }
    }
}
