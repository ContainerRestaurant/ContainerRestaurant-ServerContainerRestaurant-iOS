//
//  APIClient.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/01.
//

import Foundation
import Alamofire
import RxSwift

class APIClient {
    //로그인 토큰 생성
    static func createLoginToken(provider: String, accessToken: String, completion: @escaping (LoginModel) -> Void) {
        AF.request(Router.CreateLoginToken(provider: provider, accessToken: accessToken))
            .responseDecodable { (response: DataResponse<LoginModel, AFError>) in
                switch response.result {
                case .success(let loginModel):
                    completion(loginModel)
                case .failure(let error):
                    completion(LoginModel())
                    print("Create Login Token's Error: \(error)")
                }
            }
    }

    //내 정보 조회
    static func checkLogin(loginToken: String, completion: @escaping (UserModel) -> Void) {
        AF.request(Router.CheckLogin)
            .responseDecodable { (response: DataResponse<UserModel, AFError>) in
                switch response.result {
                case .success(let userModel):
                    completion(userModel)
                case .failure(let error):
                    completion(UserModel())
                    print("Create Login Token's Error: \(error)")
                }
            }
    }

    //사용자 정보 변경
    static func updateUserInformation(userID: Int, nickname: String, completion: @escaping (UserModel) -> Void) {
        AF.request(Router.UpdateUserInformation(userID: userID, nickname: nickname))
            .responseDecodable { (response: DataResponse<UserModel, AFError>) in
                switch response.result {
                case .success(let userModel):
                    completion(userModel)
                case .failure(let error):
                    completion(UserModel())
                    print("Update User Information's Error: \(error)")
                }
            }
    }

    //홈 탭 메인 배너
    static func mainBanner(completion: @escaping ([BannerInfoModel]) -> Void) {
        AF.request(Router.HomeBanner)
            .responseDecodable { (response: DataResponse<BannerModel, AFError>) in
                switch response.result {
                case .success(let bannerInfo):
                    completion(bannerInfo.bannerInfoList)
                case .failure(let error):
                    completion([])
                    print("Main Banner's Error: \(error)")
                }
            }
    }

    //홈 탭 메인 피드
    static func recommendFeed(completion: @escaping ([FeedPreviewModel]) -> Void ) {
        AF.request(Router.RecommendFeed)
            .responseDecodable { (response: DataResponse<TwoFeedModel, AFError>) in
                switch response.result {
                case .success(let recommendFeed):
                    completion(recommendFeed.feedPreviewList)
                case .failure(let error):
                    completion([])
                    print("Recommend Feed's Error: \(error)")
                }
            }
    }
    
    //피드 탭 카테고리 피드
    static func categoryFeed(category: String, completion: @escaping ([FeedPreviewModel]) -> Void ) {
        AF.request(Router.CategoryFeed(category: category))
            .responseDecodable { (response: DataResponse<TwoFeedModel, AFError>) in
                switch response.result {
                case .success(let categoryFeed):
                    completion(categoryFeed.feedPreviewList)
                case .failure(let error):
                    completion([])
                    print("Category Feed's Error: \(error)")
                }
            }
    }

    //해당 식당에 쓰인 피드
    static func restaurantFeed(restaurantID: Int, completion: @escaping ([FeedPreviewModel]) -> Void ) {
        AF.request(Router.RestaurantFeed(restaurantID: restaurantID))
            .responseDecodable { (response: DataResponse<TwoFeedModel, AFError>) in
                switch response.result {
                case .success(let categoryFeed):
                    completion(categoryFeed.feedPreviewList)
                case .failure(let error):
                    completion([])
                    print("Restaurant Feed's Error: \(error)")
                }
            }
    }
    
    //피드 상세
    static func feedDetail(feedID: Int, completion: @escaping (FeedDetailModel?) -> Void ) {
        AF.request(Router.FeedDetail(feedID: feedID))
            .responseDecodable { (response: DataResponse<FeedDetailModel, AFError>) in
                switch response.result {
                case .success(let feedDetail):
                    completion(feedDetail)
                case .failure(let error):
                    completion(FeedDetailModel())
                    print("Feed Detail's Error: \(error)")
                }
            }
    }
    
    //피드 상세 Rx로 감싸보기
//    static func feedDetailRx(feedID: Int) -> Observable<FeedDetailModel> {
//        return Observable.create() { emitter in
//            feedDetail(feedID: feedID) { feedDetail in
//                emitter.onNext(feedDetail!)
//                emitter.onCompleted()
//            }
//            return Disposables.create()
//        }
//    }
    
    //주변 식당 검색
    static func nearbyRestaurants(latitude: Double, longitude: Double, radius: Int, completion: @escaping ([RestaurantModel]) -> Void) {
        AF.request(Router.NearbyRestaurants(latitude: latitude, longitude: longitude, radius: radius))
            .responseDecodable { (response: DataResponse<NearybyRestaurantModel, AFError>) in
                switch response.result {
                case .success(let nearbyRestaurant):
                    completion(nearbyRestaurant.nearbyRestaurants)
                case .failure(let error):
                    completion([])
                    print("Nearby Restaurants's Error: \(error)")
                }
            }
    }
}
