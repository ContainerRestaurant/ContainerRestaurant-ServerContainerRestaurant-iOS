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
    var likeCountDriver: Driver<Int>
    var scrapCountDriver: Driver<Int>
    var categoryDriver: Driver<String>
    var restaurantNameDriver: Driver<String>
    var isWelcome: Bool = false
    var isWelcomeDriver: Driver<Bool>
    var levelOfDifficulty: Int = 1
    var userLevel: String = ""
    var mainMenuAndContainers: [MenuAndContainerModel]
    var sideMenuAndContainers: [MenuAndContainerModel]

    var content: String = ""
    var feedID: String = ""

    var comments: [CommentModel] = []

    var modules: [UICollectionViewCell.Type] = []

    init(_ feedDetail: FeedDetailModel) {
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
        
        likeCountDriver = Observable<Int>
            .just(feedDetail.likeCount)
            .asDriver(onErrorJustReturn: 0)
        
        scrapCountDriver = Observable<Int>
            .just(feedDetail.scrapCount)
            .asDriver(onErrorJustReturn: 0)

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

        levelOfDifficulty = feedDetail.difficulty
        userLevel = feedDetail.userLevel

        mainMenuAndContainers = feedDetail.mainMenu
        sideMenuAndContainers = feedDetail.subMenu

        content = feedDetail.content
        feedID = String(feedDetail.id)
    }

    func setInformationModules() {
        modules.removeAll()

        modules.append(TopSectionOnFeedDetail.self)
        modules.append(TapOnFeedDetail.self)
        modules.append(RestaurantInformationOnFeedDetail.self)
        modules.append(LevelOfDifficultyOnFeedDetail.self)
        modules.append(MenuOnFeedDetail.self)
        if sideMenuAndContainers.count > 0 { modules.append(MenuOnFeedDetail.self) }
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
        APIClient.commentsOfFeed(feedID: feedID) { [weak self] in
            self?.comments = $0
            completion()
        }
    }
}
