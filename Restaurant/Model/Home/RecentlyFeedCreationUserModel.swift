//
//  RecentlyFeedCreationUserModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/08/22.
//

import Foundation

struct RecentlyFeedCreationUserModel: Decodable {
    var users: [UserModel]

//    private enum RootKey: String, CodingKey {
//        case embedded = "_embedded"
//    }

    private enum CodingKeys: String, CodingKey {
        case users = "statisticsUserDto"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let users = try container.nestedContainer(keyedBy: Embedded.self, forKey: .embedded)

        self.users = try container.decode(Array.self, forKey: .users)
    }
}
