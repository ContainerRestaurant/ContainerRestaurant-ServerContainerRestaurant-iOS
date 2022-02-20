//
//  AppVersionModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2022/02/16.
//

import Foundation

struct AppVersionModel: Decodable {
    var minimumVersion: String
    var latestVersion: String

    private enum CodingKeys: String, CodingKey {
        case minimumVersion = "minimum"
        case latestVersion = "latest"
    }

    init() {
        self.minimumVersion = ""
        self.latestVersion = ""
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.minimumVersion = (try? container.decode(String.self, forKey: .minimumVersion)) ?? ""
        self.latestVersion = (try? container.decode(String.self, forKey: .latestVersion)) ?? ""
    }
}
