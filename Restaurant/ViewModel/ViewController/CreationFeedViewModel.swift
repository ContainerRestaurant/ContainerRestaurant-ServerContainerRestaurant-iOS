//
//  CreationFeedViewModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/27.
//

import UIKit
import RxSwift

struct CreationFeedViewModel {
    var modules: [UICollectionViewCell] = []
    var restaurantName: String = ""
    var restaurantSubject: PublishSubject<LocalSearchItem> = PublishSubject<LocalSearchItem>()
    var mainFoodHeightSubject: PublishSubject<CGFloat> = PublishSubject<CGFloat>()
    var sideFoodHeightSubject: PublishSubject<CGFloat> = PublishSubject<CGFloat>()

    init() {
        appendModule()
    }
}

extension CreationFeedViewModel {
    mutating func appendModule() {
        self.modules.append(SeparateLineCollectionViewCell())
        self.modules.append(Title16Bold())
        self.modules.append(SearchRestaurant())
        self.modules.append(SeparateLineCollectionViewCell())
        self.modules.append(Title16Bold())
        self.modules.append(SeparateLineCollectionViewCell())
        self.modules.append(FoodCategory())
        self.modules.append(SeparateLineCollectionViewCell())
        self.modules.append(SeparateLineCollectionViewCell())
        self.modules.append(SeparateLineCollectionViewCell())
        self.modules.append(Title16Bold())
        self.modules.append(SeparateLineCollectionViewCell())
        self.modules.append(CreationFeedDetail())
        self.modules.append(SeparateLineCollectionViewCell())
        self.modules.append(CreationFeedDetailSide())
        self.modules.append(LevelOfDifficultyAndWelcome())
        self.modules.append(SeparateLineCollectionViewCell())
        self.modules.append(CreationFeedImage())
    }

    func mainTitleSectionSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(24))
    }

    func searchRestaurantSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(40))
    }

    func foodCategorySize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(116))
    }

    func levelOfDifficultyAndWelcomeSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(206))
    }

    func creationFeedImage() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(432))
    }
}
