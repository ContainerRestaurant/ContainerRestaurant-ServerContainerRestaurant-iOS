//
//  HomeMainDataModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/09/03.
//

import Foundation

struct HomeMainDataModel: Decodable {
    var loginID: Int
    var myContainer: Int
    var totalContainer: Int
    var myLevelTitle: String
    var myProfile: String
    var phrase: String
    var latestWriterProfile: [String]
    var banners: [BannerInfoModel]

    private enum CodingKeys: String, CodingKey {
        case loginID = "loginId"
        case myContainer
        case totalContainer
        case myLevelTitle
        case myProfile
        case phrase
        case latestWriterProfile
        case banners
    }

    init() {
        loginID = 0
        myContainer = 0
        totalContainer = 0
        myLevelTitle = ""
        myProfile = ""
        phrase = ""
        latestWriterProfile = []
        banners = []
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.loginID = (try? container.decode(Int.self, forKey: .loginID)) ?? 0
        self.myContainer = (try? container.decode(Int.self, forKey: .myContainer)) ?? 0
        self.totalContainer = (try? container.decode(Int.self, forKey: .totalContainer)) ?? 0
        self.myLevelTitle = (try? container.decode(String.self, forKey: .myLevelTitle)) ?? ""
        self.myProfile = (try? container.decode(String.self, forKey: .myProfile)) ?? ""
        self.phrase = (try? container.decode(String.self, forKey: .phrase)) ?? ""
        self.latestWriterProfile = (try? container.decode(Array.self, forKey: .latestWriterProfile)) ?? []
        self.banners = (try? container.decode(Array.self, forKey: .banners)) ?? []
    }
}
