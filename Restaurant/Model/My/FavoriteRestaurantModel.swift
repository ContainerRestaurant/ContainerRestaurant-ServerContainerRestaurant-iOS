//
//  FavoriteRestaurantModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/09/29.
//

import Foundation

struct FavoriteRestaurantModel: Decodable {
    var favoriteRestaurants: [RestaurantModel]

    private enum RootKey: String, CodingKey {
        case embedded = "_embedded"
    }

    private enum Embedded: String, CodingKey {
        case favoriteRestaurants = "restaurantFavoriteDtoList"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let favoriteRestaurants = try container.nestedContainer(keyedBy: Embedded.self, forKey: .embedded)

        self.favoriteRestaurants = (try? favoriteRestaurants.decode(Array.self, forKey: .favoriteRestaurants)) ?? []
    }
}
