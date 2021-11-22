//
//  BannerInfoModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/29.
//

import Foundation

struct BannerInfoModel: Decodable {
    var bannerURL: String
    var contentURL: String
    var additionalURL: String
    
    private enum CodingKeys: String, CodingKey {
        case bannerURL = "bannerUrl"
        case contentURL = "contentUrl"
        case additionalURL = "additionalUrl"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.bannerURL = (try? container.decode(String.self, forKey: .bannerURL)) ?? ""
        self.contentURL = (try? container.decode(String.self, forKey: .contentURL)) ?? ""
        self.additionalURL = (try? container.decode(String.self, forKey: .additionalURL)) ?? ""
    }
}
