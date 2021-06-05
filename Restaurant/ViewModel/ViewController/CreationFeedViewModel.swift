//
//  CreationFeedViewModel.swift
//  Restaurant
//
//  Created by Lotte on 2021/05/27.
//

import UIKit
import RxSwift

struct CreationFeedViewModel {
    var modules: [UICollectionViewCell] = []
    var restaurantName: String = ""
    var restaurantNameSubject: BehaviorSubject<String> = BehaviorSubject<String>(value: "")
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
    }

    func mainTitleSectionSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(24).heightRatio())
    }

    func searchRestaurantSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(40).heightRatio())
    }

    func foodCategorySize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(116).heightRatio())
    }
}
