//
//  API.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/21.
//

import Foundation
import Alamofire

enum API {
    case test
    
    public var url: String {
        switch self {
        case .test: return "https://www.thecocktaildb.com/api/json/v1/1/filter.php?g=Cocktail_glass"
        }
    }
}
//enum APIType {
//    case test
//}
//
//class API {
//    static let shared = API()
//
//    func url(type: APIType) -> String {
//        switch type {
//        case .test: return "https://www.thecocktaildb.com/api/json/v1/1/filter.php?g=Cocktail_glass"
//        }
//    }
//
//    func get(url: String) {
//        AF.request(url).responseJSON { (response) in
//            switch response.result {
//            case .success(let obj):
//                do {
//                    let jsonData = try JSONSerialization.data(withJSONObject: obj, options: .fragmentsAllowed)
//                    let instanceData = try JSONDecoder().decode(TestCodable.self, from: jsonData)
//
//                    print(instanceData.drinks[0].idDrink)
//                } catch {
//                    print(error.localizedDescription)
//                }
//            case .failure(let e):
//                print(e.localizedDescription)
//            }
//        }
//    }
//}
