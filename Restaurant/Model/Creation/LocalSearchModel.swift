//
//  LocalSearchModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/01.
//

import Foundation

struct LocalSearch: Decodable {
    var items: [LocalSearchItem]
}

struct LocalSearchItem: Decodable {
    var title: String
    var link: String
    var category: String
    var description: String
    var telephone: String
    var address: String
    var roadAddress: String
    var mapx: String
    var mapy: String

    private enum CodingKeys: CodingKey {
        case title
        case link
        case category
        case description
        case telephone
        case address
        case roadAddress
        case mapx
        case mapy
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.title = (try? container.decode(String.self, forKey: .title)) ?? ""
        self.link = (try? container.decode(String.self, forKey: .link)) ?? ""
        self.category = (try? container.decode(String.self, forKey: .category)) ?? ""
        self.description = (try? container.decode(String.self, forKey: .description)) ?? ""
        self.telephone = (try? container.decode(String.self, forKey: .telephone)) ?? ""
        self.address = (try? container.decode(String.self, forKey: .address)) ?? ""
        self.roadAddress = (try? container.decode(String.self, forKey: .roadAddress)) ?? ""
        self.mapx = (try? container.decode(String.self, forKey: .mapx)) ?? ""
        self.mapy = (try? container.decode(String.self, forKey: .mapy)) ?? ""
    }
}
