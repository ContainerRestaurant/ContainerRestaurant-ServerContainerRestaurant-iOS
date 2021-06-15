//
//  UserModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/16.
//

import Foundation

struct UserModel: Decodable {
    var id: Int
    var email: String
    var nickname: String
    var profile: String
    var level: Int
    var feedCount: Int
    var scrapCount: Int
    var bookmarkedCount: Int
    
    private enum CodingKeys: CodingKey {
        case id
        case email
        case nickname
        case profile
        case level
        case feedCount
        case scrapCount
        case bookmarkedCount
    }
    
    init() {
        id = 0
        email = "e-mail"
        nickname = "용기낸식당"
        profile = ""
        level = 1
        feedCount = 999
        scrapCount = 999
        bookmarkedCount = 999
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = (try? container.decode(Int.self, forKey: .id)) ?? 0
        self.email = (try? container.decode(String.self, forKey: .email)) ?? ""
        self.nickname = (try? container.decode(String.self, forKey: .nickname)) ?? ""
        self.profile = (try? container.decode(String.self, forKey: .profile)) ?? ""
        self.level = (try? container.decode(Int.self, forKey: .level)) ?? 0
        self.feedCount = (try? container.decode(Int.self, forKey: .feedCount)) ?? 0
        self.scrapCount = (try? container.decode(Int.self, forKey: .scrapCount)) ?? 0
        self.bookmarkedCount = (try? container.decode(Int.self, forKey: .bookmarkedCount)) ?? 0
    }
}
