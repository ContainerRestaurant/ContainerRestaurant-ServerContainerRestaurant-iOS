//
//  Router.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/30.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    case CreateLoginToken(provider: String, accessToken: String)
    case CheckLogin
    case UpdateUserInformation(userID: Int, nickname: String)
    case HomeBanner
    case MostFeedCreationUsers
    case RecentlyFeedCreationUsers
    case RecommendFeed
    case CategoryFeed(category: String)
    case RestaurantFeed(restaurantID: Int)
    case FeedDetail(feedID: Int)
    case CreateFeedComment(feedID: String, content: String)
    case CreateFeedReplyComment(feedID: String, content: String, uppperReplyID: Int)
    case FeedComment(feedID: String)
    case NearbyRestaurants(latitude: Double, longitude: Double, radius: Int)

    static var baseURLString = "http://ec2-52-78-66-184.ap-northeast-2.compute.amazonaws.com"
    
    private var method: HTTPMethod {
        switch self {
        case .CreateLoginToken: return .post
        case .CheckLogin: return .get
        case .UpdateUserInformation: return .patch
        case .MostFeedCreationUsers: return .get
        case .RecentlyFeedCreationUsers: return .get
        case .HomeBanner: return .get
        case .RecommendFeed: return .get
        case .CategoryFeed: return .get
        case .RestaurantFeed: return .get
        case .FeedDetail: return .get
        case .CreateFeedComment: return .post
        case .CreateFeedReplyComment: return .post
        case .FeedComment: return .get
        case .NearbyRestaurants: return .get
        }
    }

    private var path: String {
        switch self {
        case .CreateLoginToken: return "/api/user"
        case .CheckLogin: return "/api/user"
        case .UpdateUserInformation(let userID, _): return "/api/user/\(userID)"
        case .HomeBanner: return "/banners"
        case .MostFeedCreationUsers: return "/api/statistics/top"
        case .RecentlyFeedCreationUsers: return "/api/statistics/latest"
        case .RecommendFeed: return "/api/feed/recommend"
        case .CategoryFeed: return "/api/feed"
        case .RestaurantFeed(let restaurantID): return "/api/feed/restaurant/\(restaurantID)"
        case .FeedDetail(let feedID): return "/api/feed/\(feedID)"
        case .CreateFeedComment(let feedID, _): return "/api/comment/feed/\(feedID)"
        case .CreateFeedReplyComment(let feedID, _, _): return "/api/comment/feed/\(feedID)"
        case .FeedComment(let feedID): return "/api/comment/feed/\(feedID)"
        case .NearbyRestaurants(let latitude, let longitude, let radius): return "/api/restaurant/\(latitude)/\(longitude)/\(radius)"
        }
    }

    private var parameters: Parameters? {
        switch self {
        case .CreateLoginToken(let provider, let accessToken): return ["provider": provider, "accessToken": accessToken]
        case .CheckLogin: return nil
        case .UpdateUserInformation(_, let nickname): return ["nickname": nickname]
        case .HomeBanner: return nil
        case .MostFeedCreationUsers: return nil
        case .RecentlyFeedCreationUsers: return nil
        case .RecommendFeed: return nil
        case .CategoryFeed(let category): return category.isEmpty ? nil : ["category": category]
        case .RestaurantFeed: return nil
        case .FeedDetail: return nil
        case .CreateFeedComment(_, let content): return ["content": content]
        case .CreateFeedReplyComment(_, let content, let uppperReplyID): return ["content": content, "upperReplyId": String(uppperReplyID)]
        case .FeedComment: return nil
        case .NearbyRestaurants(_, _, _): return nil
        }
    }

    func asURLRequest() throws -> URLRequest {
        let baseURL = try Router.baseURLString.asURL()
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        urlRequest.method = method

        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        switch self {
        case .CheckLogin, .UpdateUserInformation:
            urlRequest.setValue("Bearer \(UserDataManager.sharedInstance.loginToken)", forHTTPHeaderField: "Authorization")
        default: break
        }
        
        /* 추후 참고
        //urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        //urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)    }
         */

        if let parameters = parameters {
            do {
                switch method {
                case .get:
                    urlRequest = try URLEncodedFormParameterEncoder().encode(parameters as? [String: String], into: urlRequest)
                case .post, .patch:
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
