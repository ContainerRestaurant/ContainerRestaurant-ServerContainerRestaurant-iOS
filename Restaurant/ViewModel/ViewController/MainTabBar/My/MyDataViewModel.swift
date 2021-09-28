//
//  MyDataViewModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/09/28.
//

import Foundation

class MyDataViewModel {
    var feeds: [FeedPreviewModel]
    var restaurants: [RestaurantModel]

    init(feeds: [FeedPreviewModel] = [], restaurants: [RestaurantModel] = []) {
        self.feeds = feeds
        self.restaurants = restaurants
    }
}
