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
    var userNickname: Driver<String>
    var thumbnailURL: Observable<String>
    var likeCount: Driver<Int>
    var scrapCount: Driver<Int>
    var content: Observable<String>
    
    init(_ feedDetail: FeedDetailModel) {
        userNickname = Observable<String>
            .just(feedDetail.userNickname)
            .asDriver(onErrorJustReturn: "")
        
        thumbnailURL = Observable<String>
            .just(feedDetail.thumbnailURL)
        
        likeCount = Observable<Int>
            .just(feedDetail.likeCount)
            .asDriver(onErrorJustReturn: 0)
        
        scrapCount = Observable<Int>
            .just(feedDetail.scrapCount)
            .asDriver(onErrorJustReturn: 0)

        content = Observable<String>
            .just(feedDetail.content)
    }
}
