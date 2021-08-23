//
//  MostFeedCreationUserModel.swift
//  Restaurant
//
//  Created by Lotte on 2021/08/22.
//

import Foundation

struct MostFeedCreationUserModel: Decodable {
    var users: [UserModel]

    private enum RootKey: String, CodingKey {
        case embedded = "_embedded"
    }

    private enum Embedded: String, CodingKey {
        case user = "statisticsUserDtoList"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let users = try container.nestedContainer(keyedBy: Embedded.self, forKey: .embedded)

        self.users = try users.decode(Array.self, forKey: .user)
    }
}
