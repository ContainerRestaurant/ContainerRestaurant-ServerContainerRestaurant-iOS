//
//  API.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/21.
//

import Foundation
import Alamofire
import RxSwift

var baseURL = "http://ec2-52-78-66-184.ap-northeast-2.compute.amazonaws.com/"

struct API {
    func recommendFeed(subject: PublishSubject<RecommendFeed>) {
        let url = "\(baseURL)api/feed/recommend"

        AF.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let obj):
                do {
                    let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .fragmentsAllowed)
                    let instanceData = try JSONDecoder().decode(RecommendFeed.self, from: dataJSON)

                    subject.onNext(instanceData)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
}
