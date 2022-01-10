//
//  FeedDetailModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/14.
//

import Foundation

struct FeedDetailModel: Decodable {
    var id: Int
    var userID: Int
    var restaurantID: Int
    var userNickname: String
    var userLevel: String
    var userProfileImage: String
    var restaurantName: String
    var latitude: Double
    var longitude: Double
    var category: String
    var thumbnailURL: String
    var content: String
    var welcome: Bool
    var difficulty: Int
    var likeCount: Int
    var scrapCount: Int
    var replyCount: Int
    var isContainerFriendly: Bool
    var mainMenu: [MenuAndContainerModel]
    var subMenu: [MenuAndContainerModel]
    var isLike: Bool
    var isScraped: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id
        case userID = "ownerId"
        case restaurantID = "restaurantId"
        case userNickname = "ownerNickname"
        case userLevel = "ownerContainerLevel"
        case userProfileImage = "ownerProfile"
        case restaurantName
        case latitude
        case longitude
        case category
        case thumbnailURL = "thumbnailUrl"
        case content
        case welcome
        case difficulty
        case likeCount
        case scrapCount
        case replyCount
        case isContainerFriendly = "isContainerFriendly"
        case mainMenu
        case subMenu
        case isLike
        case isScraped
    }
    
    init() {
        self.id = 0
        self.userID =  0
        self.restaurantID =  0
        self.userNickname = ""
        self.userLevel = ""
        self.userProfileImage = ""
        self.restaurantName =  ""
        self.latitude = 0.0
        self.longitude = 0.0
        self.category = ""
        self.thumbnailURL = ""
        self.content = ""
        self.welcome =  false
        self.difficulty = 1
        self.likeCount = 0
        self.scrapCount = 0
        self.replyCount = 0
        self.isContainerFriendly = false
        self.mainMenu = []
        self.subMenu = []
        self.isLike = false
        self.isScraped = false
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = (try? container.decode(Int.self, forKey: .id)) ?? 0
        self.userID = (try? container.decode(Int.self, forKey: .userID)) ?? 0
        self.restaurantID = (try? container.decode(Int.self, forKey: .restaurantID)) ?? 0
        self.userNickname = (try? container.decode(String.self, forKey: .userNickname)) ?? ""
        self.userLevel = (try? container.decode(String.self, forKey: .userLevel)) ?? ""
        self.userProfileImage = (try? container.decode(String.self, forKey: .userProfileImage)) ?? ""
        self.restaurantName = (try? container.decode(String.self, forKey: .restaurantName)) ?? ""
        self.latitude = (try? container.decode(Double.self, forKey: .latitude)) ?? 0.0
        self.longitude = (try? container.decode(Double.self, forKey: .longitude)) ?? 0.0
        let convertedCategory = convertCategory(category: (try? container.decode(String.self, forKey: .category)) ?? "")
        self.category = convertedCategory
        self.thumbnailURL = (try? container.decode(String.self, forKey: .thumbnailURL)) ?? ""
        self.content = (try? container.decode(String.self, forKey: .content)) ?? ""
        self.welcome = (try? container.decode(Bool.self, forKey: .welcome)) ?? false
        self.difficulty = (try? container.decode(Int.self, forKey: .difficulty)) ?? 1
        self.likeCount = (try? container.decode(Int.self, forKey: .likeCount)) ?? 0
        self.scrapCount = (try? container.decode(Int.self, forKey: .scrapCount)) ?? 0
        self.replyCount = (try? container.decode(Int.self, forKey: .replyCount)) ?? 0
        self.isContainerFriendly = (try? container.decode(Bool.self, forKey: .isContainerFriendly)) ?? false
        self.mainMenu = (try? container.decode(Array.self, forKey: .mainMenu)) ?? []
        self.subMenu = (try? container.decode(Array.self, forKey: .subMenu)) ?? []
        self.isLike = (try? container.decode(Bool.self, forKey: .isLike)) ?? false
        self.isScraped = (try? container.decode(Bool.self, forKey: .isScraped)) ?? false

        func convertCategory(category: String) -> String {
            switch category {
            case "KOREAN": return "한식"
            case "NIGHT_MEAL": return "야식"
            case "CHINESE": return "중식"
            case "SCHOOL_FOOD": return "분식"
            case "FAST_FOOD": return "패스트푸드"
            case "ASIAN_AND_WESTERN": return "아시안/양식"
            case "COFFEE_AND_DESSERT": return "카페/디저트"
            case "JAPANESE": return "돈가스/회/일식"
            case "CHICKEN_AND_PIZZA": return "치킨/피자"
            case "": return ""
            default: return ""
            }
        }
    }
}
