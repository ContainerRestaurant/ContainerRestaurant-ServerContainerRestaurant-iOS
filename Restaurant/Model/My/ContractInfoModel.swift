//
//  ContractInfoModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/11/23.
//

import Foundation

struct ContractInfoModel: Decodable {
    var contractInfoList: [ContractInfo]

    private enum RootKey: String, CodingKey {
        case embedded = "_embedded"
    }

    private enum Embedded: String, CodingKey {
        case contractInfoDtoList = "contractInfoDtoList"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let favoriteRestaurants = try container.nestedContainer(keyedBy: Embedded.self, forKey: .embedded)

        self.contractInfoList = (try? favoriteRestaurants.decode(Array.self, forKey: .contractInfoDtoList)) ?? []
    }
}

struct ContractInfo: Decodable {
    var title: String
    var article: String
}
