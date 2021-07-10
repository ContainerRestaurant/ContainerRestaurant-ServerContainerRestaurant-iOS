//
//  APIClient.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/01.
//

import Foundation
import Alamofire

class APIClient {
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
}
