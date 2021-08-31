//
//  CommentOfFeedModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/08/30.
//

import Foundation

struct CommentOfFeedModel: Decodable {
    var comments: [CommentModel]

    private enum RootKey: String, CodingKey {
        case embedded = "_embedded"
    }

    private enum Embedded: String, CodingKey {
        case comments = "commentInfoDtoList"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let comments = try container.nestedContainer(keyedBy: Embedded.self, forKey: .embedded)

        self.comments = try comments.decode(Array.self, forKey: .comments)
    }
}
