//
//  BannerInfoModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/29.
//

import Foundation

struct BannerInfoModel: Decodable {
    var bannerID: Int
    var bannerURL: String
    
    private enum CodingKeys: String, CodingKey {
        case bannerID = "bannerId"
        case bannerURL = "bannerUrl"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.bannerID = (try? container.decode(Int.self, forKey: .bannerID)) ?? 0
        self.bannerURL = (try? container.decode(String.self, forKey: .bannerURL)) ?? ""
    }
}
