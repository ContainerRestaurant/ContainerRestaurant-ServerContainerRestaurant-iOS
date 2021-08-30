//
//  CommentModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/08/30.
//

import Foundation

struct CommentModel: Decodable {
    var id: Int
    var content: String
    var isDeleted: Bool
    var likeCount: Int
    var userID: Int
    var userNickname: String
    var userProfile: String
    var userLevelTitle: String
    var createdDate: String
    var isLike: Bool
//    var commentReply: [CommentReplyModel]

    private enum CodingKeys: String, CodingKey {
        case id
        case content
        case isDeleted
        case likeCount
        case userID = "ownerId"
        case userNickname = "ownerNickName"
        case userProfile = "ownerProfile"
        case userLevelTitle = "ownerLevelTitle"
        case createdDate
        case isLike
    }

    init() {
        self.id = 0
        self.content =  ""
        self.isDeleted = false
        self.likeCount = 0
        self.userID = 0
        self.userNickname = ""
        self.userProfile =  ""
        self.userLevelTitle = ""
        self.createdDate = ""
        self.isLike = false
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = (try? container.decode(Int.self, forKey: .id)) ?? 0
        self.content = (try? container.decode(String.self, forKey: .content)) ?? ""
        self.isDeleted = (try? container.decode(Bool.self, forKey: .isDeleted)) ?? false
        self.likeCount = (try? container.decode(Int.self, forKey: .likeCount)) ?? 0
        self.userID = (try? container.decode(Int.self, forKey: .userID)) ?? 0
        self.userNickname = (try? container.decode(String.self, forKey: .userNickname)) ?? ""
        self.userProfile = (try? container.decode(String.self, forKey: .userProfile)) ?? ""
        self.userLevelTitle = (try? container.decode(String.self, forKey: .userLevelTitle)) ?? ""
        self.createdDate = (try? container.decode(String.self, forKey: .createdDate)) ?? ""
        self.isLike = (try? container.decode(Bool.self, forKey: .isLike)) ?? false
    }
}
