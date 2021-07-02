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

    private var method: HTTPMethod {
        switch self {
        case .HomeBanner: return .get
        case .RecommendFeed: return .get
        }
    }

    private var path: String {
        switch self {
        case .HomeBanner: return "/banners"
//        case .RecommendFeed: return "/api/feed/recommend"
        case .RecommendFeed: return "/api/feed"
        }
    }

    private var parameters: Parameters? {
        switch self {
        case .HomeBanner: return nil
        case .RecommendFeed: return nil
        }
    }

    func asURLRequest() throws -> URLRequest {
        let baseURL = try "http://ec2-52-78-66-184.ap-northeast-2.compute.amazonaws.com".asURL()
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))

        urlRequest.httpMethod = method.rawValue
        /* 추후 참고
        //urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        //urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)    }
         */

        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
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
