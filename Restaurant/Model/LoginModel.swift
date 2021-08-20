//
//  LoginModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/08/18.
//

import Foundation

struct LoginModel: Decodable {
    var id: Int
    var token: String

    private enum CodingKeys: CodingKey {
        case id
        case token
    }

    init() {
        id = 0
        token = ""
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = (try? container.decode(Int.self, forKey: .id)) ?? 0
        self.token = (try? container.decode(String.self, forKey: .token)) ?? ""
    }
}
