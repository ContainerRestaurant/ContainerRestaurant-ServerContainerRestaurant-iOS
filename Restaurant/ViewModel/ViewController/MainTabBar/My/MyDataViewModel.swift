//
//  MyDataViewModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/09/28.
//

import Foundation

class MyDataViewModel {
    var feeds: [FeedPreviewModel]
    var restaurants: [RestaurantFavoriteDtoList]

    init(feeds: [FeedPreviewModel] = [], restaurants: [RestaurantFavoriteDtoList] = []) {
        self.feeds = feeds
        self.restaurants = restaurants
    }
}
