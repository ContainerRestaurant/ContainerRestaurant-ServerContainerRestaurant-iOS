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
    var latitude: Double = 0
    var longitude: Double = 0
    var nearbyRestaurantsFlag: PublishSubject<Void> = PublishSubject<Void>()
    
    
    init(_ afterSearchingRestaurantSubject: PublishSubject<[RestaurantModel]>) {
        afterSearchingRestaurantSubject.subscribe(onNext: { [weak self] in
            self?.nearbyRestaurants = $0
            self?.nearbyRestaurantsFlag.onNext(())
        })
        .disposed(by: disposeBag)
    }
    
    func fetchNearbyRestaurants() {
        APIClient.nearbyRestaurants(latitude: latitude, longitude: longitude, radius: 200) { [weak self] nearbyRestaurants in
            self?.nearbyRestaurants = nearbyRestaurants
            self?.nearbyRestaurantsFlag.onNext(())
        }
    }
}
