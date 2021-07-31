//
//  RestaurantSummaryInformationViewModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/31.
//

import UIKit

class RestaurantSummaryInformationViewModel {
    var modules: [UICollectionViewCell.Type] = []
    var restaurant: RestaurantModel?

    init(_ restaurant: RestaurantModel) {
        self.restaurant = restaurant

        appendModule()
    }
}

extension RestaurantSummaryInformationViewModel {
    private func appendModule() {
        self.modules.append(WelcomeViewInRestaurantSummaryInfo.self)
        self.modules.append(RestaurantSummaryInformation.self)
        self.modules.append(MainImageInRestaurantSummaryInfo.self)
        self.modules.append(FeedInRestaurantSummaryInfo.self)
    }
}
