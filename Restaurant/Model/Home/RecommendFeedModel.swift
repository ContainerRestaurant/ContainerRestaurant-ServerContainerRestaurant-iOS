//
//  RecommendFeedModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/24.
//

import Foundation

///추천피드 모델
struct RecommendFeedModel: Decodable {
    var feedPreviewList: [FeedPreviewModel]

    private enum RootKey: String, CodingKey {
        case embedded = "_embedded"
    }

    private enum Embedded: String, CodingKey {
        case feedPreviewList = "feedPreviewDtoList"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let feedPreviewList = try container.nestedContainer(keyedBy: Embedded.self, forKey: .embedded)

        self.feedPreviewList = try feedPreviewList.decode(Array.self, forKey: .feedPreviewList)
    }
}

struct FeedPreviewModel: Decodable {
    var id: Int
    var thumbnailUrl: String
    var ownerNickname: String
    var content: String
    var likeCount: Int
    var replyCount: Int

    private enum CodingKeys: CodingKey {
        case id, thumbnailUrl, ownerNickname, content
        case likeCount, replyCount
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = (try? container.decode(Int.self, forKey: .id)) ?? 0
        self.thumbnailUrl = (try? container.decode(String.self, forKey: .thumbnailUrl)) ?? ""
        self.ownerNickname = (try? container.decode(String.self, forKey: .ownerNickname)) ?? ""
        self.content = (try? container.decode(String.self, forKey: .content)) ?? ""
        self.likeCount = (try? container.decode(Int.self, forKey: .likeCount)) ?? 0
        self.replyCount = (try? container.decode(Int.self, forKey: .replyCount)) ?? 0
    }
}
