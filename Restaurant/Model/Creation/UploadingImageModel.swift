//
//  UploadingImageModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/26.
//

import Foundation

struct UploadingImageModel: Decodable {
    var id: Int
//    var feed: String
    var url: String
//    var links: Links
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case url = "url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = (try? container.decode(Int.self, forKey: .id)) ?? 0
        self.url = (try? container.decode(String.self, forKey: .url)) ?? ""
    }
}
