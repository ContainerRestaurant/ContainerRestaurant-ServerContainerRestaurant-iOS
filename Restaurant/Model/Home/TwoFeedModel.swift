//
//  TwoFeedModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/24.
//

import Foundation

///2단형 피드 모델
struct TwoFeedModel: Decodable {
    var feedPreviewList: [FeedPreviewModel]
    var size: Int // Todo : page struct 안에 담기
    var totalElements: Int // Todo : page struct 안에 담기
    var totalPages: Int // Todo : page struct 안에 담기
    var number: Int // Todo : page struct 안에 담기

    private enum RootKey: String, CodingKey {
        case embedded = "_embedded"
        case page = "page"
    }

    private enum Embedded: String, CodingKey {
        case feedPreviewList = "feedPreviewDtoList"
    }

    private enum Page: CodingKey {
        case size
        case totalElements
        case totalPages
        case number
    }

    init() {
        self.feedPreviewList = []
        self.size = 0
        self.totalElements = 0
        self.totalPages = 0
        self.number = 0
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let feedPreviewList = try container.nestedContainer(keyedBy: Embedded.self, forKey: .embedded)
        let pageInformation = try? container.nestedContainer(keyedBy: Page.self, forKey: .page)

        self.feedPreviewList = (try? feedPreviewList.decode(Array.self, forKey: .feedPreviewList)) ?? []
        self.size = (try? pageInformation?.decode(Int.self, forKey: .size)) ?? 0
        self.totalElements = (try? pageInformation?.decode(Int.self, forKey: .totalElements)) ?? 0
        self.totalPages = (try? pageInformation?.decode(Int.self, forKey: .totalPages)) ?? 0
        self.number = (try? pageInformation?.decode(Int.self, forKey: .number)) ?? 0
    }
}

struct FeedPreviewModel: Decodable {
    var id: Int
    var thumbnailUrl: String
    var userNickname: String
    var content: String
    var likeCount: Int
    var commentCount: Int
    var isWelcome: Bool
    var isLike: Bool
    var isScraped: Bool

    private enum CodingKeys: String, CodingKey {
        case id, thumbnailUrl
        case userNickname = "ownerNickname"
        case content
        case likeCount
        case commentCount = "replyCount"
        case isWelcome = "isContainerFriendly"
        case isLike
        case isScraped = "isScraped"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = (try? container.decode(Int.self, forKey: .id)) ?? 0
        self.thumbnailUrl = (try? container.decode(String.self, forKey: .thumbnailUrl)) ?? ""
        self.userNickname = (try? container.decode(String.self, forKey: .userNickname)) ?? ""
        self.content = (try? container.decode(String.self, forKey: .content)) ?? ""
        self.likeCount = (try? container.decode(Int.self, forKey: .likeCount)) ?? 0
        self.commentCount = (try? container.decode(Int.self, forKey: .commentCount)) ?? 0
        self.isWelcome = (try? container.decode(Bool.self, forKey: .isWelcome)) ?? false
        self.isLike = (try? container.decode(Bool.self, forKey: .isLike)) ?? false
        self.isScraped = (try? container.decode(Bool.self, forKey: .isScraped)) ?? false
    }
}
