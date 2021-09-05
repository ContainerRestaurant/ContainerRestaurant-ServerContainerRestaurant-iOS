//
//  NearybyRestaurantModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/21.
//

import Foundation

struct NearybyRestaurantModel: Decodable {
    var nearbyRestaurants: [RestaurantModel]
    
    private enum RootKey: String, CodingKey {
        case embedded = "_embedded"
    }
    
    private enum Embedded: String, CodingKey {
        case nearbyRestaurants = "restaurantNearInfoDtoList"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let nearbyRestaurants = try container.nestedContainer(keyedBy: Embedded.self, forKey: .embedded)
        
        self.nearbyRestaurants = (try? nearbyRestaurants.decode(Array.self, forKey: .nearbyRestaurants)) ?? []
    }
}
