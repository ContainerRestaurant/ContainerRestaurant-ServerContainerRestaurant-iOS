//
//  TestCodable.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/21.
//

import Foundation

struct TestCodable: Decodable {
    var drinks: [Drinks]
}

struct Drinks: Decodable {
    var idDrink: String
    var strDrink: String
    var strDrinkThumb: String
}
