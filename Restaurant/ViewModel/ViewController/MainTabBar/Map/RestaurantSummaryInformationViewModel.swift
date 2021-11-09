//
//  RestaurantSummaryInformationViewModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/31.
//

import UIKit
import RxSwift

class RestaurantSummaryInformationViewModel {
    var modules: [UICollectionViewCell.Type] = []
    var restaurant: RestaurantModel
    var restaurantFeed: [FeedPreviewModel]
    var latitudeInCenterOfMap: Double
    var longitudeInCenterOfMap: Double
    var afterSearchingRestaurantSubject: PublishSubject<([RestaurantModel],Bool)>

    init(_ restaurant: RestaurantModel, _ restaurantFeed: [FeedPreviewModel], _ latitude: Double, _ longitude: Double, _ afterSearchingRestaurantSubject: PublishSubject<([RestaurantModel],Bool)>) {
        self.restaurant = restaurant
        self.restaurantFeed = restaurantFeed
        self.latitudeInCenterOfMap = latitude
        self.longitudeInCenterOfMap = longitude
        self.afterSearchingRestaurantSubject = afterSearchingRestaurantSubject

        appendModule()
    }
}

extension RestaurantSummaryInformationViewModel {
    private func appendModule() {
        if restaurant.isContainerFriendly { self.modules.append(WelcomeViewInRestaurantSummaryInfo.self) }
        self.modules.append(RestaurantSummaryInformation.self)
        self.modules.append(MainImageInRestaurantSummaryInfo.self)
        self.modules.append(FeedInRestaurantSummaryInfo.self)
    }
}
