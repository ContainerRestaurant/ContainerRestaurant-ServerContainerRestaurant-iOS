//
//  CreationFeedResponseModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/11/22.
//

import Foundation

struct CreationFeedResponseModel: Decodable {
    var feedID: Int
    var levelUp: LevelUpModel

    private enum CodingKeys: CodingKey {
        case feedId
        case levelUp
    }

    init() {
        feedID = 0
        levelUp = LevelUpModel()
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.feedID = (try? container.decode(Int.self, forKey: .feedId)) ?? 0
        self.levelUp = (try? container.decode(LevelUpModel.self, forKey: .levelUp)) ?? LevelUpModel()
    }
}

struct LevelUpModel: Codable {
    var levelFeedCount: Int
    var from: String
    var to: String

    private enum CodingKeys: CodingKey {
        case levelFeedCount
        case from
        case to
    }

    init() {
        levelFeedCount = 0
        from = ""
        to = ""
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.levelFeedCount = (try? container.decode(Int.self, forKey: .levelFeedCount)) ?? 0
        self.from = (try? container.decode(String.self, forKey: .from)) ?? ""
        self.to = (try? container.decode(String.self, forKey: .to)) ?? ""
    }
}
