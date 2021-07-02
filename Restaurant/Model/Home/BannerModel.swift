//
//  BannerModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/29.
//

import Foundation

struct BannerModel: Decodable {
    var bannerInfoList: [BannerInfoModel]
    
    private enum RootKey: String, CodingKey {
        case embedded = "_embedded"
    }
    
    private enum Embedded: String, CodingKey {
        case bannerInfoList = "bannerInfoDtoList"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let bannerInfoList = try container.nestedContainer(keyedBy: Embedded.self, forKey: .embedded)
        
        self.bannerInfoList = try bannerInfoList.decode(Array.self, forKey: .bannerInfoList)
    }
}

struct BannerInfoModel: Decodable {
    var title: String
    var bannerURL: String
    var contentURL: String
    var additionalURL: String
    
    private enum CodingKeys: CodingKey {
        case title
        case bannerURL
        case contentURL
        case additionalURL
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = (try? container.decode(String.self, forKey: .title)) ?? ""
        self.bannerURL = (try? container.decode(String.self, forKey: .bannerURL)) ?? ""
        self.contentURL = (try? container.decode(String.self, forKey: .contentURL)) ?? ""
        self.additionalURL = (try? container.decode(String.self, forKey: .additionalURL)) ?? ""
    }
}
