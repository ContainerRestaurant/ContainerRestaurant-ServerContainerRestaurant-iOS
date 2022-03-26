//
//  Router.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/30.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    case AppVersion
    case CreateLoginToken(provider: String, accessToken: String)
    case CheckLogin
    case UpdateUserNickname(userID: Int, nickname: String)
    case UpdateUserProfile(userID: Int, profileID: Int)
    case UpdateDeviceToken(pushToken: String)
    case DeleteDeviceTokenOfUser(userID: Int)
    case DeleteDeviceTokenOfTable(pushTokenID: Int)
    case UnregisterUser(userID: Int)
    case CheckUser(userID: Int)
    case HomeMainData
    case ContainerOfEveryone
    case RecommendFeed
    case UserFeed(userID: Int, size: Int)
//    case UploadFeed(feedModel: FeedModel)
    case ReportFeed(feedID: String)
    case ScrapedFeed(userID: Int, size: Int)
    case FavoriteRestaurant
    case RegistFavoriteRestaurant(restaurantID: Int)
    case DeleteFavoriteRestaurant(restaurantID: Int)
    case Feed(category: String, sort: String, page: Int)
    case RestaurantFeed(restaurantID: Int)
    case LikeFeed(feedID: Int, cancel: Bool)
    case ScrapFeed(feedID: Int, cancel: Bool)
    case DeleteFeed(feedID: String)
    case FeedDetail(feedID: Int)
    case FeedComment(feedID: String)
    case CreateFeedComment(feedID: String, content: String)
    case UpdateFeedComment(commentID: Int, content: String)
    case DeleteFeedComment(commentID: Int)
    case ReportComment(commentID: Int)
    case LikeComment(commentID: Int)
    case DeleteCommentLike(commentID: Int)
    case CreateFeedReplyComment(feedID: String, content: String, uppperReplyID: Int)
    case NearbyRestaurants(latitude: Double, longitude: Double, radius: Int)
    case Contract

    static var baseURLString = "http://beta.hellozin.net"

    private var method: HTTPMethod {
        switch self {
        case .AppVersion: return .get
        case .CreateLoginToken: return .post
        case .CheckLogin: return .get
        case .UpdateUserNickname: return .patch
        case .UpdateUserProfile: return .patch
        case .UpdateDeviceToken: return .post
        case .DeleteDeviceTokenOfUser: return .delete
        case .DeleteDeviceTokenOfTable: return .delete
        case .UnregisterUser: return .delete
        case .CheckUser: return .get
        case .HomeMainData: return .get
        case .ContainerOfEveryone: return .get
        case .RecommendFeed: return .get
        case .UserFeed: return .get
//        case .UploadFeed: return .post
        case .ReportFeed: return .post
        case .ScrapedFeed: return .get
        case .FavoriteRestaurant: return .get
        case .RegistFavoriteRestaurant: return .post
        case .DeleteFavoriteRestaurant: return .delete
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
        case .ReportComment: return .post
        case .LikeComment: return .post
        case .DeleteCommentLike: return .delete
        case .CreateFeedReplyComment: return .post
        case .NearbyRestaurants: return .get
        case .Contract: return .get
        }
    }

    private var path: String {
        switch self {
        case .AppVersion: return "api/version/ios"
        case .CreateLoginToken: return "/api/user"
        case .CheckLogin: return "/api/user"
        case .UpdateUserNickname(let userID, _): return "/api/user/\(userID)"
        case .UpdateUserProfile(let userID, _): return "/api/user/\(userID)"
        case .UpdateDeviceToken(let pushToken): return "/api/push/token/\(pushToken)"
        case .DeleteDeviceTokenOfUser(let userID): return "/api/user/\(userID)/push/token"
        case .DeleteDeviceTokenOfTable(let pushTokenID): return "/api/push/token/\(pushTokenID)"
        case .UnregisterUser(let userID): return "/api/user/\(userID)"
        case .CheckUser(let userID): return "/api/user/\(userID)"
        case .HomeMainData: return "/api/home"
        case .ContainerOfEveryone: return "/api/statistics/total-container"
        case .RecommendFeed: return "/api/feed/recommend"
        case .UserFeed(let userID, _): return "/api/feed/user/\(userID)"
//        case .UploadFeed: return "/api/feed"
        case .ReportFeed(let feedID): return "/api/report/feed/\(feedID)"
        case .ScrapedFeed(let userID, _): return "/api/feed/user/\(userID)/scrap"
        case .FavoriteRestaurant: return "/api/favorite/restaurant"
        case .RegistFavoriteRestaurant(let restaurantID): return "/api/favorite/restaurant/\(restaurantID)"
        case .DeleteFavoriteRestaurant(let restaurantID): return "/api/favorite/restaurant/\(restaurantID)"
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
        case .ReportComment(let commentID): return "/api/report/feed/\(commentID)"
        case .LikeComment(let commentID): return "/api/like/comment/\(commentID)"
        case .DeleteCommentLike(let commentID): return "/api/like/comment/\(commentID)"
        case .CreateFeedReplyComment(let feedID, _, _): return "/api/comment/feed/\(feedID)"
        case .NearbyRestaurants(let latitude, let longitude, let radius): return "/api/restaurant/\(latitude)/\(longitude)/\(radius)"
        case .Contract: return "/api/contract"
        }
    }

    private var parameters: Parameters? {
        switch self {
        case .AppVersion: return nil
        case .CreateLoginToken(let provider, let accessToken): return ["provider": provider, "accessToken": accessToken]
        case .CheckLogin: return nil
        case .UpdateUserNickname(_, let nickname): return ["nickname": nickname]
        case .UpdateUserProfile(_, let profileID): return ["profileId": String(profileID)]
        case .UpdateDeviceToken: return nil
        case .DeleteDeviceTokenOfUser: return nil
        case .DeleteDeviceTokenOfTable: return nil
        case .UnregisterUser: return nil
        case .CheckUser: return nil
        case .HomeMainData: return nil
        case .ContainerOfEveryone: return nil
        case .RecommendFeed: return nil
        case .UserFeed(_, let size): return ["size": String(size)]
//        case .UploadFeed(let feedModel):
//            var parameter: [String: Any] = [
//                "restaurantCreateDto": feedModel.restaurantCreateDto,
//                "category": feedModel.category,
//                "mainMenu": feedModel.mainMenu,
//                "difficulty": feedModel.difficulty,
//                "welcome": feedModel.welcome,
//                "content": feedModel.content
//            ]
//            if !(feedModel.subMenu?.isEmpty ?? true) {
//                parameter["subMenu"] = feedModel.subMenu
//            }
//            if let thumbnailImageId = feedModel.thumbnailImageId {
//                parameter["thumbnailImageId"] = thumbnailImageId
//            }
//            return parameter
        case .ReportFeed: return nil
        case .ScrapedFeed(_, let size): return ["size": String(size)]
        case .FavoriteRestaurant: return nil
        case .RegistFavoriteRestaurant: return nil
        case .DeleteFavoriteRestaurant: return nil
        case .Feed(let category, let sort, let page): return ["category": category, "sort": sort, "page": String(page)]
        case .RestaurantFeed: return nil //Todo: 페이징 처리
        case .LikeFeed: return nil
        case .ScrapFeed: return nil
        case .DeleteFeed: return nil
        case .FeedDetail: return nil
        case .FeedComment: return nil
        case .CreateFeedComment(_, let content): return ["content": content]
        case .UpdateFeedComment(_, let content): return ["content": content]
        case .DeleteFeedComment: return nil
        case .ReportComment: return nil
        case .LikeComment: return nil
        case .DeleteCommentLike: return nil
        case .CreateFeedReplyComment(_, let content, let uppperReplyID): return ["content": content, "upperReplyId": String(uppperReplyID)]
        case .NearbyRestaurants(_, _, _): return nil
        case .Contract: return nil
        }
    }

    func asURLRequest() throws -> URLRequest {
        let baseURL = try Router.baseURLString.asURL()
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        urlRequest.method = method

        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        switch self {
//        case .CheckLogin, .UpdateUserNickname, .HomeMainData, .FavoriteRestaurant, .LikeFeed, .ScrapFeed, .DeleteFeed, .CreateFeedComment, .UpdateFeedComment, .DeleteFeedComment, .CreateFeedReplyComment:
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
