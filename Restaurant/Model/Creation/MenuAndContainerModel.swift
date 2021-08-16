//
//  FoodAndContainer.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/26.
//

import Foundation

struct MenuAndContainerModel: Codable {
    var menuName: String
    var container: String
    
    private enum CodingKeys: CodingKey {
        case menuName
        case container
    }
    
    init() {
        self.menuName = ""
        self.container = ""
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.menuName = (try? container.decode(String.self, forKey: .menuName)) ?? ""
        self.container = (try? container.decode(String.self, forKey: .container)) ?? ""
    }
}
