//
//  NickNameValidationModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/15.
//

import Foundation

struct NickNameValidationModel: Decodable {
    var nickname: String
    var exists: Bool
    
    private enum CodingKeys: CodingKey {
        case nickname
        case exists
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.nickname = (try? container.decode(String.self, forKey: .nickname)) ?? ""
        self.exists = (try? container.decode(Bool.self, forKey: .exists)) ?? true
    }
}
