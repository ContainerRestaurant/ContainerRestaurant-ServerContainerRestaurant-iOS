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
    case CheckUser(userID: Int)
    case HomeMainData
    case ContainerOfEveryone
    case RecommendFeed
    case UserFeed(userID: Int)
    case ScrapedFeed(userID: Int)
    case FavoriteRestaurant
    case Feed(category: String, sort: String)
    case RestaurantFeed(restaurantID: Int)
    case LikeFeed(feedID: Int, cancel: Bool)
    case ScrapFeed(feedID: Int, cancel: Bool)
    case DeleteFeed(feedID: String)
    case FeedDetail(feedID: Int)
    case FeedComment(feedID: String)
    case CreateFeedComment(feedID: String, content: String)
    case UpdateFeedComment(commentID: Int, content: String)
    case DeleteFeedComment(commentID: Int)
    case CreateFeedReplyComment(feedID: String, content: String, uppperReplyID: Int)
    case NearbyRestaurants(latitude: Double, longitude: Double, radius: Int)

    static var baseURLString = "http://ec2-52-78-66-184.ap-northeast-2.compute.amazonaws.com"
    
    private var method: HTTPMethod {
        switch self {
        case .CreateLoginToken: return .post
        case .CheckLogin: return .get
        case .UpdateUserInformation: return .patch
        case .CheckUser: return .get
        case .HomeMainData: return .get
        case .ContainerOfEveryone: return .get
        case .RecommendFeed: return .get
        case .UserFeed: return .get
        case .ScrapedFeed: return .get
        case .FavoriteRestaurant: return .get
        case .Feed: return .get
        case .RestaurantFeed: return .get
        case .LikeFeed(_, let cancel): return cancel ? .delete : .post
        case .ScrapFeed(_, let cancel): return cancel ? .delete : .post
        case .DeleteFeed: return .delete
        case .FeedDetail: return .get
        case .FeedComment: return .get
        case .CreateFeedComment: return .post
        case .UpdateFeedComment: return .patch
        case .DeleteFeedComment: return .delete
        case .CreateFeedReplyComment: return .post
        case .NearbyRestaurants: return .get
        }
    }

    private var path: String {
        switch self {
        case .CreateLoginToken: return "/api/user"
        case .CheckLogin: return "/api/user"
        case .UpdateUserInformation(let userID, _): return "/api/user/\(userID)"
        case .CheckUser(let userID): return "/api/user/\(userID)"
        case .HomeMainData: return "/api/home"
        case .ContainerOfEveryone: return "/api/statistics/total-container"
        case .RecommendFeed: return "/api/feed/recommend"
        case .UserFeed(let userID): return "/api/feed/user/\(userID)"
        case .ScrapedFeed(let userID): return "/api/feed/user/\(userID)/scrap"
        case .FavoriteRestaurant: return "api/favorite/restaurant"
        case .Feed: return "/api/feed"
        case .RestaurantFeed(let restaurantID): return "/api/feed/restaurant/\(restaurantID)"
        case .LikeFeed(let feedID, _): return "/api/like/feed/\(feedID)"
        case .ScrapFeed(let feedID, _): return "/api/scrap/\(feedID)"
        case .DeleteFeed(let feedID): return "/api/feed/\(feedID)"
        case .FeedDetail(let feedID): return "/api/feed/\(feedID)"
        case .FeedComment(let feedID): return "/api/comment/feed/\(feedID)"
        case .CreateFeedComment(let feedID, _): return "/api/comment/feed/\(feedID)"
        case .UpdateFeedComment(let commentID, _): return "/api/comment/\(commentID)"
        case .DeleteFeedComment(let commentID): return "/api/comment/\(commentID)"
        case .CreateFeedReplyComment(let feedID, _, _): return "/api/comment/feed/\(feedID)"
        case .NearbyRestaurants(let latitude, let longitude, let radius): return "/api/restaurant/\(latitude)/\(longitude)/\(radius)"
        }
    }

    private var parameters: Parameters? {
        switch self {
        case .CreateLoginToken(let provider, let accessToken): return ["provider": provider, "accessToken": accessToken]
        case .CheckLogin: return nil
        case .UpdateUserInformation(_, let nickname): return ["nickname": nickname]
        case .CheckUser: return nil
        case .HomeMainData: return nil
        case .ContainerOfEveryone: return nil
        case .RecommendFeed: return nil //Todo: 페이징 처리
        case .UserFeed: return nil //Todo: 페이징 처리
        case .ScrapedFeed: return nil //Todo: 페이징 처리
        case .FavoriteRestaurant: return nil
        case .Feed(let category, let sort): return ["category": category, "sort": sort] //Todo: 페이징 처리
        case .RestaurantFeed: return nil //Todo: 페이징 처리
        case .LikeFeed: return nil
        case .ScrapFeed: return nil
        case .DeleteFeed: return nil
        case .FeedDetail: return nil
        case .FeedComment: return nil
        case .CreateFeedComment(_, let content): return ["content": content]
        case .UpdateFeedComment(_, let content): return ["content": content]
        case .DeleteFeedComment: return nil
        case .CreateFeedReplyComment(_, let content, let uppperReplyID): return ["content": content, "upperReplyId": String(uppperReplyID)]
        case .NearbyRestaurants(_, _, _): return nil
        }
    }

    func asURLRequest() throws -> URLRequest {
        let baseURL = try Router.baseURLString.asURL()
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        urlRequest.method = method

        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        switch self {
//        case .CheckLogin, .UpdateUserInformation, .HomeMainData, .FavoriteRestaurant, .LikeFeed, .ScrapFeed, .DeleteFeed, .CreateFeedComment, .UpdateFeedComment, .DeleteFeedComment, .CreateFeedReplyComment:
        if !UserDataManager.sharedInstance.loginToken.isEmpty {
            urlRequest.setValue("Bearer \(UserDataManager.sharedInstance.loginToken)", forHTTPHeaderField: "Authorization")
        }
//        default: break
//        }
        
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
