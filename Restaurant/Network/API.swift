//
//  API.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/21.
//

import Foundation
import Alamofire
import RxSwift

var baseURL = "http://ec2-52-78-66-184.ap-northeast-2.compute.amazonaws.com"

struct API {
    
}

//MARK: 홈
extension API {
    //추천피드
    func recommendFeed(subject: PublishSubject<RecommendFeed>) {
        let url = "\(baseURL)/api/feed/recommend"

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

//MARK: 피드쓰기
extension API {
    //지역검색
    func localSearch(text: String, subject: PublishSubject<LocalSearch>) {
        let url = "https://openapi.naver.com/v1/search/local"
        let httpHeaders: HTTPHeaders = [
            "X-Naver-Client-Id": "zJ4xl5NeU12vREYMTgji",
            "X-Naver-Client-Secret": "UFCyKRkPkk"
        ]
        let param: Parameters = [
            "query": text,
            "display": 5
        ]

        AF.request(url, parameters: param, headers: httpHeaders).responseJSON { (response) in
            switch response.result {
            case .success(let obj):
                do {
                    let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .fragmentsAllowed)
                    let instanceData = try JSONDecoder().decode(LocalSearch.self, from: dataJSON)

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

//MARK: 로그인
extension API {
    //사용자 정보 생성(가입)
    func createUser(provider: String, accessToken: String) {
        let url = "\(baseURL)/api/user"
        let params: Parameters = [
            "provider": provider,
            "accessToken": accessToken
        ]
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                //            switch response.result {
                //            case .success:
                //                print("POST 성공")
                //            case .failure(let error):
                //                print("에러다: \(error)")
                //            }
                print("회원가입------------------")
                print(response)
                print("회원가입------------------")
                API().askUser()
            }
    }
    
    //내 정보 또는 사용자 정보 조회
    func askUser(isLoginSubject: PublishSubject<Bool> = PublishSubject<Bool>(), userDataSubject: PublishSubject<UserModel> = PublishSubject<UserModel>(), userID: Int = Int.max) {
        let url = "\(baseURL)/api/user\(userID == Int.max ? "" : "/\(userID)")"
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type": "application/json", "Accept":"application/json"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                print("로그인됐다------------------------------------")
                switch response.result {
                case .success(let obj):
                    do {
                        isLoginSubject.onNext(true)
                        let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .fragmentsAllowed)
                        let instanceData = try JSONDecoder().decode(UserModel.self, from: dataJSON)

                        userDataSubject.onNext(instanceData)
                        //카카오 소셜 로그인으로 회원가입 시에 UserDefault에 UserID 저장
                        UserDataManager.sharedInstance.userID = instanceData.id
                        print(instanceData)
                    } catch {
                        print(error.localizedDescription)
                        isLoginSubject.onNext(false)
                        userDataSubject.onNext(UserModel())
                    }
                case .failure(let e):
                    print(e.localizedDescription)
                    isLoginSubject.onNext(false)
                    userDataSubject.onNext(UserModel())
                }
                print("로그인됐다------------------------------------")
            }
    }
    
    //로그아웃
    func logoutUser() {
        let url = "\(baseURL)/logout"
        
        AF.request(url,
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type": "application/json", "Accept":"application/json"])
            .validate(statusCode: 200..<300)
            .responseJSON { (json) in
                print("로그아웃------------------------------------")
                print(json)
                print("로그아웃------------------------------------")
            }
    }

    //닉네임 유효성 검사
    func validateNickName(nickName: String, subject: PublishSubject<Bool>) {
        let url = "\(baseURL)/api/user/nickname/exists"
        let param: Parameters = [
            "nickname": nickName
        ]
        
        AF.request(url,
                   method: .get,
                   parameters: param,
                   encoding: URLEncoding.default,
                   headers: ["Content-Type": "application/json", "Accept":"application/json"])
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(let obj):
                    do {
                        let dataJSON = try JSONSerialization.data(withJSONObject: obj, options: .fragmentsAllowed)
                        let instanceData = try JSONDecoder().decode(NickNameValidationModel.self, from: dataJSON)

                        subject.onNext(instanceData.exists)
                    } catch {
                        print(error.localizedDescription)
                        subject.onNext(true)
                    }
                case .failure(let e):
                    print(e.localizedDescription)
                    subject.onNext(true)
                }
            }
    }
    
    //닉네임 변경
    func updateNickname(userID: Int, nickname: String) {
        let url = "\(baseURL)/api/user/\(userID)"
        let param: Parameters = [
            "nickname": nickname,
        ]
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: param, options: [])
        } catch {
            print("http Body Error")
        }
        
        AF.request(request).responseString { (response) in
            switch response.result {
            case .success:
                print("PATCH 성공")
            case .failure(let error):
                print("에러다: \(error)")
            }
        }
    }
}
