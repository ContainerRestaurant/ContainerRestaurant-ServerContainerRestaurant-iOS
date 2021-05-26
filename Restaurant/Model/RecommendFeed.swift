//
//  RecommendFeed.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/24.
//

import Foundation

struct RecommendFeed: Decodable {
    var _embedded: Embedded
}

struct Embedded: Decodable {
    var feedPreviewDtoList: [FeedPreviewDtoList]
}

struct FeedPreviewDtoList: Decodable {
    var id: Int
    var thumbnailUrl: String
//    var ownerNickname: String
    var content: String
    var likeCount: Int
    var replyCount: Int
}
