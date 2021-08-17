//
//  RestaurantSummaryInformationViewModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/31.
//

import UIKit

class RestaurantSummaryInformationViewModel {
    var modules: [UICollectionViewCell.Type] = []
    var restaurant: RestaurantModel
    var restaurantFeed: [FeedPreviewModel]

    init(_ restaurant: RestaurantModel, _ restaurantFeed: [FeedPreviewModel]) {
        self.restaurant = restaurant
        self.restaurantFeed = restaurantFeed

        appendModule()
    }
}

extension RestaurantSummaryInformationViewModel {
    private func appendModule() {
        if restaurant.isWelcome { self.modules.append(WelcomeViewInRestaurantSummaryInfo.self) }
        self.modules.append(RestaurantSummaryInformation.self)
        self.modules.append(MainImageInRestaurantSummaryInfo.self)
        self.modules.append(FeedInRestaurantSummaryInfo.self)
    }
}
