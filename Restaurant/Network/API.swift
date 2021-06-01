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

    func searchLocal() {
        let url = "https://openapi.naver.com/v1/search/local"
        let httpHeaders: HTTPHeaders = [
            "X-Naver-Client-Id": "zJ4xl5NeU12vREYMTgji",
            "X-Naver-Client-Secret": "UFCyKRkPkk"
        ]
        let param: Parameters = [
            "query": "엽떡",
            "display": 5
        ]

        AF.request(url, parameters: param, headers: httpHeaders).responseJSON { (response) in
            switch response.result {
            case .success(let obj):
                do {
                    let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .fragmentsAllowed)
                    let instanceData = try JSONDecoder().decode(LocalSearch.self, from: dataJSON)
                    print("성공 => \(instanceData)")
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
}
