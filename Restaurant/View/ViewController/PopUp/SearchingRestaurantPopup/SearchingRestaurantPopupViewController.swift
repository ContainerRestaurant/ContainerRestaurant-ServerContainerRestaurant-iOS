//
//  SearchingRestaurantPopupViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/23.
//

import UIKit
import NMapsMap
import RxSwift

class SearchingRestaurantPopupViewController: BaseViewController, Storyboard {
    weak var coordinator: SearchingRestaurantPopupCoordinator?
    var (latitude, longitude): (Double, Double) = (0, 0)
    var afterSearchingRestaurantSubject: PublishSubject<[RestaurantModel]> = PublishSubject<[RestaurantModel]>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchNearbyRestaurants()
        APIClient.nearbyRestaurants(latitude: self.latitude, longitude: self.longitude, radius: 20000) { [weak self] nearbyRestaurants in
            self?.dismiss(animated: false, completion: nil)
            self?.afterSearchingRestaurantSubject.onNext(nearbyRestaurants)
        }
        print("SearchingRestaurantPopupViewController viewDidLoad()")
    }
    
    deinit {
        print("SearchingRestaurantPopupViewController Deinit")
    }
}

extension SearchingRestaurantPopupViewController {
    private func fetchNearbyRestaurants() {
        guard let locationCoordinate = CLLocationManager().location?.coordinate else { return }
        self.latitude = locationCoordinate.latitude
        self.longitude = locationCoordinate.longitude
    }
}
