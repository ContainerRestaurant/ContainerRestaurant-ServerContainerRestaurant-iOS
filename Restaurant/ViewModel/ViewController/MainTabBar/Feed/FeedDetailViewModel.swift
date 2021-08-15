//
//  FeedDetailViewModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/14.
//

import Foundation
import RxSwift
import RxCocoa

class FeedDetailViewModel {
    var userNicknameDriver: Driver<String>
    var thumbnailURLObservable: Observable<String>
    var likeCountDriver: Driver<Int>
    var scrapCountDriver: Driver<Int>

    var contentObservable: Observable<String>

    var categoryDriver: Driver<String>
    var restaurantNameDriver: Driver<String>
    var isWelcome: Bool = false
    var isWelcomeDriver: Driver<Bool>

    init(_ feedDetail: FeedDetailModel) {
        userNicknameDriver = Observable<String>
            .just(feedDetail.userNickname)
            .asDriver(onErrorJustReturn: "")
        
        thumbnailURLObservable = Observable<String>
            .just(feedDetail.thumbnailURL)
        
        likeCountDriver = Observable<Int>
            .just(feedDetail.likeCount)
            .asDriver(onErrorJustReturn: 0)
        
        scrapCountDriver = Observable<Int>
            .just(feedDetail.scrapCount)
            .asDriver(onErrorJustReturn: 0)

        contentObservable = Observable<String>
            .just(feedDetail.content)

        categoryDriver = Observable<String>
            .just(feedDetail.category)
            .asDriver(onErrorJustReturn: "")

        restaurantNameDriver = Observable<String>
            .just(feedDetail.restaurantName)
            .asDriver(onErrorJustReturn: "")

        isWelcome = feedDetail.isWelcome
        isWelcomeDriver = Observable<Bool>
            .just(feedDetail.isWelcome)
            .asDriver(onErrorJustReturn: false)
    }
}
