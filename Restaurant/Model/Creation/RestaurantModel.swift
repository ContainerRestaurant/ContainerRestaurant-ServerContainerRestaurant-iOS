//
//  RestaurantModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/26.
//

import Foundation

struct RestaurantModel: Codable {
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
    
    private enum CodingKeys: CodingKey {
        case name
        case address
        case latitude
        case longitude
    }
    
    init() {
        self.name = ""
        self.address = ""
        self.latitude = 0.0
        self.longitude = 0.0
    }
    
    init(name: String, address: String, latitude: Double, longitude: Double) {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = (try? container.decode(String.self, forKey: .name)) ?? ""
        self.address = (try? container.decode(String.self, forKey: .address)) ?? ""
        self.latitude = (try? container.decode(Double.self, forKey: .latitude)) ?? 0
        self.longitude = (try? container.decode(Double.self, forKey: .longitude)) ?? 0
    }
}
