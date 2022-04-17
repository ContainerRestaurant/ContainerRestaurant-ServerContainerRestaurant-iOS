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
    var thumbnailURLObservable: Observable<String>
    var userProfileImageObservable: Observable<String>
    var userNicknameDriver: Driver<String>
    var userLevelDriver: Driver<String>
    var isLikeSubject: BehaviorSubject<Bool>
    var likeCountSubject: BehaviorSubject<Int>
    var isScrapSubject: BehaviorSubject<Bool>
    var scrapCountSubject: BehaviorSubject<Int>
    var categoryDriver: Driver<String>
    var restaurantNameDriver: Driver<String>
    var isWelcomeDriver: Driver<Bool>

    var feedDetail: FeedDetailModel = FeedDetailModel()
    var comments: [CommentModel] = []

    var modules: [UICollectionViewCell.Type] = []

    init(_ feedDetail: FeedDetailModel) {
        self.feedDetail = feedDetail

        thumbnailURLObservable = Observable<String>
            .just(feedDetail.thumbnailURL)

        userProfileImageObservable = Observable<String>
            .just(feedDetail.userProfileImage)

        userNicknameDriver = Observable<String>
            .just(feedDetail.userNickname)
            .asDriver(onErrorJustReturn: "")

        userLevelDriver = Observable<String>
            .just(feedDetail.userLevel)
            .asDriver(onErrorJustReturn: "")

        isLikeSubject = BehaviorSubject<Bool>(value: feedDetail.isLike)
        likeCountSubject = BehaviorSubject<Int>(value: feedDetail.likeCount)

        isScrapSubject = BehaviorSubject<Bool>(value: feedDetail.isScraped)
        scrapCountSubject = BehaviorSubject<Int>(value: feedDetail.scrapCount)

        categoryDriver = Observable<String>
            .just(feedDetail.category)
            .asDriver(onErrorJustReturn: "")

        restaurantNameDriver = Observable<String>
            .just(feedDetail.restaurantName)
            .asDriver(onErrorJustReturn: "")

        isWelcomeDriver = Observable<Bool>
            .just(feedDetail.welcome)
            .asDriver(onErrorJustReturn: false)
    }

    func setInformationModules() {
        modules.removeAll()

        modules.append(TopSectionOnFeedDetail.self)
        modules.append(TapOnFeedDetail.self)
        modules.append(RestaurantInformationOnFeedDetail.self)
        modules.append(LevelOfDifficultyOnFeedDetail.self)
        modules.append(MenuOnFeedDetail.self)
        if feedDetail.subMenu.count > 0 {
            modules.append(MenuOnFeedDetail.self)
        }
        modules.append(CommentSectionOnFeedDetail.self)
    }

    func setContentModules() {
        modules.removeAll()

        modules.append(TopSectionOnFeedDetail.self)
        modules.append(TapOnFeedDetail.self)
        modules.append(ContentOnFeedDetail.self)
        modules.append(CommentSectionOnFeedDetail.self)
    }
}

extension FeedDetailViewModel {
    //댓글 조회
    func fetchCommentsOfFeed(completion: @escaping () -> ()) {
        APIClient.commentsOfFeed(feedID: String(feedDetail.id)) { [weak self] in
            self?.comments = $0
            completion()
        }
    }
}
