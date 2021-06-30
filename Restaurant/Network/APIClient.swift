//
//  APIClient.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/01.
//

import Foundation
import Alamofire

class APIClient {
    static func mainBanner(completion: @escaping ([BannerInfo]) -> Void) {
        AF.request(Router.HomeBanner)
            .responseDecodable { (response: DataResponse<BannerModel, AFError>) in
                switch response.result {
                case .success(let bannerInfo):
                    completion(bannerInfo.bannerInfo)
                case .failure(let error):
                    print("Main Banner's Error: \(error)")
                }
            }
    }
}
