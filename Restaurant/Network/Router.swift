//
//  Router.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/30.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    case HomeBanner
    case RecommendFeed
    case CategoryFeed(category: String)
    case RestaurantFeed(restaurantID: Int)
    case FeedDetail(feedID: Int)
    case NearbyRestaurants(latitude: Double, longitude: Double, radius: Int)

    static var baseURLString = "http://ec2-52-78-66-184.ap-northeast-2.compute.amazonaws.com"
    
    private var method: HTTPMethod {
        switch self {
        case .HomeBanner: return .get
        case .RecommendFeed: return .get
        case .CategoryFeed: return .get
        case .RestaurantFeed: return .get
        case .FeedDetail: return .get
        case .NearbyRestaurants: return .get
        }
    }

    private var path: String {
        switch self {
        case .HomeBanner: return "/banners"
        case .RecommendFeed: return "/api/feed/recommend"
        case .CategoryFeed: return "/api/feed"
        case .RestaurantFeed(let restaurantID): return "/api/feed/restaurant/\(restaurantID)"
        case .FeedDetail(let feedID): return "/api/feed/\(feedID)"
        case .NearbyRestaurants(let latitude, let longitude, let radius): return "/api/restaurant/\(latitude)/\(longitude)/\(radius)"
        }
    }

    private var parameters: Parameters? {
        switch self {
        case .HomeBanner: return nil
        case .RecommendFeed: return nil
        case .CategoryFeed(let category): return category.isEmpty ? nil : ["category": category]
        case .RestaurantFeed: return nil
        case .FeedDetail: return nil
        case .NearbyRestaurants(_, _, _): return nil
        }
    }

    func asURLRequest() throws -> URLRequest {
        let baseURL = try Router.baseURLString.asURL()
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        urlRequest.method = method
        
        /* 추후 참고
        //urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        //urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)    }
         */

        if let parameters = parameters {
            do {
                switch method {
                case .get:
                    urlRequest = try URLEncodedFormParameterEncoder().encode(parameters as? [String: String], into: urlRequest)
                case .post:
                    urlRequest = try JSONParameterEncoder().encode(parameters as? [String: String], into: urlRequest)                default: break
                }
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }

        return urlRequest
    }
}


// 추후 참고
//import Foundation
//
//struct K {
//    struct ProductionServer {
//        static let baseURL = "https://api.medium.com/v1"
//    }
//
//    struct APIParameterKey {
//        static let password = "password"
//        static let email = "email"
//    }
//}
//
//enum HTTPHeaderField: String {
//    case authentication = "Authorization"
//    case contentType = "Content-Type"
//    case acceptType = "Accept"
//    case acceptEncoding = "Accept-Encoding"
//}
//
//enum ContentType: String {
//    case json = "application/json"
//}
