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
    var searchRestaurantSubject: PublishSubject<String> = PublishSubject<String>() //아직 안씀
    var mainFoodHeightSubject: PublishSubject<CGFloat> = PublishSubject<CGFloat>()
    var sideFoodHeightSubject: PublishSubject<CGFloat> = PublishSubject<CGFloat>()

    init() {
        appendModule()
    }
}

extension CreationFeedViewModel {
    mutating func appendModule() {
        self.modules.append(Title16Bold())
        self.modules.append(SearchRestaurant())
        self.modules.append(Title16Bold())
        self.modules.append(CreationFeedDetail())
        self.modules.append(CreationFeedDetailSide())
    }

    func mainTitleSectionSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 24)
    }

    func searchRestaurantSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 40)
    }
    
    func creationFeedDetailSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 500)
    }
}
