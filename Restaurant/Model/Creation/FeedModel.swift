//
//  FeedModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/26.
//

import Foundation

struct FeedModel: Codable {
    var restaurantCreateDto: RestaurantModel
    var category: String
    var mainMenu: [FoodAndContainerModel]
    var subMenu: [FoodAndContainerModel]
    var difficulty: Int
    var welcome: Bool
    var thumbnailImageId: Int
    var content: String
    
    private enum CodingKeys: CodingKey {
        case restaurantCreateDto
        case category
        case mainMenu
        case subMenu
        case difficulty
        case welcome
        case thumbnailImageId
        case content
    }
    
    init() {
        self.restaurantCreateDto = RestaurantModel()
        self.category = ""
        self.mainMenu = []
        self.subMenu = []
        self.difficulty = 1
        self.welcome = false
        self.thumbnailImageId = 0
        self.content = ""
    }
    
    init(restaurantCreateDto: RestaurantModel, category: String, mainMenu: [FoodAndContainerModel], subMenu: [FoodAndContainerModel], difficulty: Int, welcome: Bool, thumbnailImageID: Int, content: String = "") {
        self.restaurantCreateDto = restaurantCreateDto
        self.category = category
        self.mainMenu = mainMenu
        self.subMenu = subMenu
        self.difficulty = difficulty
        self.welcome = welcome
        self.thumbnailImageId = thumbnailImageID
        self.content = content
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.restaurantCreateDto = (try? container.decode(RestaurantModel.self, forKey: .restaurantCreateDto)) ?? RestaurantModel()
        self.category = (try? container.decode(String.self, forKey: .category)) ?? ""
        self.mainMenu = (try? container.decode(Array.self, forKey: .mainMenu)) ?? []
        self.subMenu = (try? container.decode(Array.self, forKey: .subMenu)) ?? []
        self.difficulty = (try? container.decode(Int.self, forKey: .difficulty)) ?? 0
        self.welcome = (try? container.decode(Bool.self, forKey: .welcome)) ?? false
        self.thumbnailImageId = (try? container.decode(Int.self, forKey: .thumbnailImageId)) ?? 0
        self.content = (try? container.decode(String.self, forKey: .content)) ?? ""
    }
}
