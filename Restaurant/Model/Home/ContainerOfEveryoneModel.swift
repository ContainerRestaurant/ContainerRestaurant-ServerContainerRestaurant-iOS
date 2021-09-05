//
//  ContainerOfEveryoneModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/09/04.
//

import Foundation

struct ContainerOfEveryoneModel: Decodable {
    var mostFeedWriters: [UserModel]
    var recentlyFeedWriters: [UserModel]
    var writerCount: Int
    var feedCount: Int

    private enum CodingKeys: String, CodingKey {
        case mostFeedWriters = "topWriters"
        case recentlyFeedWriters = "latestWriters"
        case writerCount
        case feedCount
    }

    init() {
        mostFeedWriters = []
        recentlyFeedWriters = []
        writerCount = 0
        feedCount = 0
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.mostFeedWriters = (try? container.decode(Array.self, forKey: .mostFeedWriters)) ?? []
        self.recentlyFeedWriters = (try? container.decode(Array.self, forKey: .recentlyFeedWriters)) ?? []
        self.writerCount = (try? container.decode(Int.self, forKey: .writerCount)) ?? 0
        self.feedCount = (try? container.decode(Int.self, forKey: .feedCount)) ?? 0
    }
}
