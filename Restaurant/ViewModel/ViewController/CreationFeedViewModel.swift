//
//  CreationFeedViewModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/27.
//

import UIKit
import RxSwift

struct CreationFeedViewModel {
    var modules: [UICollectionViewCell.Type] = []
    // MARK: - 식당 이름
    var restaurant: LocalSearchItem?
    var restaurantName: String = ""
    var restaurantSubject: PublishSubject<LocalSearchItem> = PublishSubject<LocalSearchItem>()
    // MARK: - 음식 카테고리
    var selectedCategory: String = "KOREAN"
    var selectedCategorySubject: PublishSubject<String> = PublishSubject<String>()
    // MARK: - 상세 내역
    var mainMenuAndContainer: [MenuAndContainerModel] = []
    var mainMenuAndContainerSubject: PublishSubject<[MenuAndContainerModel]> = PublishSubject<[MenuAndContainerModel]>()
    var sideMenuAndContainer: [MenuAndContainerModel] = []
    var sideMenuAndContainerSubject: PublishSubject<[MenuAndContainerModel]> = PublishSubject<[MenuAndContainerModel]>()
    var mainFoodHeightSubject: PublishSubject<CGFloat> = PublishSubject<CGFloat>()
    var sideFoodHeightSubject: PublishSubject<CGFloat> = PublishSubject<CGFloat>()
    // MARK: - 난이도
    var levelOfDifficulty: Int = 1
    var levelOfDifficultySubject: PublishSubject<Int> = PublishSubject<Int>()
    // MARK: - 환영 여부
    var isWelcome: Bool = false
    var isWelcomeSubject: PublishSubject<Bool> = PublishSubject<Bool>()
    // MARK: - 이미지 & 경험담
    var imageID: Int?
    var imageIDFlagSubject: PublishSubject<Void> = PublishSubject<Void>()
    var reuseImage: UIImage?
    var reuseImageSubject: PublishSubject<UIImage?> = PublishSubject<UIImage?>()
    var imageSubject: PublishSubject<UIImage?> = PublishSubject<UIImage?>()
    var contentsTextSubject: PublishSubject<String> = PublishSubject<String>()
    var contentsText: String = ""

    let registerSubject: PublishSubject<Bool> = PublishSubject<Bool>()

    init() {
        appendModule()
    }
}

extension CreationFeedViewModel {
    mutating func appendModule() {
        self.modules.append(SeparateLineCollectionViewCell.self)
        self.modules.append(Title16Bold.self)
        self.modules.append(SearchRestaurant.self)
        self.modules.append(SeparateLineCollectionViewCell.self)
        self.modules.append(Title16Bold.self)
        self.modules.append(SeparateLineCollectionViewCell.self)
        self.modules.append(FoodCategory.self)
        self.modules.append(SeparateLineCollectionViewCell.self)
        self.modules.append(SeparateLineCollectionViewCell.self)
        self.modules.append(SeparateLineCollectionViewCell.self)
        self.modules.append(Title16Bold.self)
        self.modules.append(SeparateLineCollectionViewCell.self)
        self.modules.append(CreationFeedDetail.self)
        self.modules.append(SeparateLineCollectionViewCell.self)
        self.modules.append(CreationFeedDetailSide.self)
        self.modules.append(LevelOfDifficultyAndWelcome.self)
        self.modules.append(SeparateLineCollectionViewCell.self)
        self.modules.append(CreationFeedImage.self)
    }

    func mainTitleSectionSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(24))
    }

    func searchRestaurantSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(60))
    }

    func foodCategorySize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(116))
    }

    func levelOfDifficultyAndWelcomeSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(206))
    }

    func creationFeedImage() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(579))
    }
}
