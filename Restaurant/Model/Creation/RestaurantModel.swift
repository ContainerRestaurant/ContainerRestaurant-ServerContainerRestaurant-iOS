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
    
    //주변 식당 정보에서 추가
    var id: Int
    var imagePath: String
    var difficultyAverage: Double
    var feedCount: Int
    var isContainerFriendly: Bool

    //즐겨찾기한 식당 정보에서 추가
    var isFavorite: Bool

    var bestMenu: [String]
    
    private enum CodingKeys: String, CodingKey {
        case name
        case address
        case latitude
        case longitude
        
        case id
        case imagePath = "image_path"
        case difficultyAverage = "difficultyAvg"
        case feedCount
        case isContainerFriendly
        case isFavorite

        case bestMenu
    }
    
    init() {
        self.name = ""
        self.address = ""
        self.latitude = 0.0
        self.longitude = 0.0
        
        id = 0
        imagePath = ""
        difficultyAverage = 0.0
        feedCount = 0
        isContainerFriendly = false
        isFavorite = false

        bestMenu = []
    }
    
    init(name: String, address: String, latitude: Double, longitude: Double, id: Int = 0, imagePath: String = "", difficultyAverage: Double = 0.0, feedCount: Int = 0, isContainerFriendly: Bool = false, isFavorite: Bool = false) {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        
        self.id = id
        self.imagePath = imagePath
        self.difficultyAverage = difficultyAverage
        self.feedCount = feedCount
        self.isContainerFriendly = isContainerFriendly
        self.isFavorite = isFavorite

        self.bestMenu = []
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.name = (try? container.decode(String.self, forKey: .name)) ?? ""
        self.address = (try? container.decode(String.self, forKey: .address)) ?? ""
        self.latitude = (try? container.decode(Double.self, forKey: .latitude)) ?? 0
        self.longitude = (try? container.decode(Double.self, forKey: .longitude)) ?? 0
        
        self.id = (try? container.decode(Int.self, forKey: .id)) ?? 0
        self.imagePath = (try? container.decode(String.self, forKey: .imagePath)) ?? ""
        self.difficultyAverage = (try? container.decode(Double.self, forKey: .difficultyAverage)) ?? 0.0
        self.feedCount = (try? container.decode(Int.self, forKey: .feedCount)) ?? 0
        self.isContainerFriendly = (try? container.decode(Bool.self, forKey: .isContainerFriendly)) ?? false
        self.isFavorite = (try? container.decode(Bool.self, forKey: .isFavorite)) ?? false

        self.bestMenu = (try? container.decode(Array.self, forKey: .bestMenu)) ?? []
    }
}
