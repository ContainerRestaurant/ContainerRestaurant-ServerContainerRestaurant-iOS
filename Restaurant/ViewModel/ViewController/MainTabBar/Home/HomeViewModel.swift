//
//  HomeViewModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/10.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewModel {
    var modules: [UICollectionViewCell.Type] = []
    var recommendFeeds: [FeedPreviewModel] = []
    var homeMainData: HomeMainDataModel = HomeMainDataModel()

//    var recommendFeeds: Driver<[FeedPreviewModel]> {
//        return Observable
//            .just(recommendFeed)
//            .asDriver(onErrorJustReturn: [])
//    }
    
    init(_ recommendFeeds: [FeedPreviewModel], _ homeMainData: HomeMainDataModel) {
        self.recommendFeeds = recommendFeeds
        self.homeMainData = homeMainData
        
        appendModule()
    }
}

//MARK: - Module Size
extension HomeViewModel {
    func appendModule() {
        self.modules.append(MainTitleSection.self)
        self.modules.append(MainBanner.self)
        self.modules.append(SeparateLineCollectionViewCell.self)
        self.modules.append(Title16Bold.self)
        self.modules.append(TwoFeedInLineCollectionView.self)
        self.modules.append(ViewMoreButton.self)
        self.modules.append(FooterSection.self)
    }

    func mainTitleSectionSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 344)
    }

    func mainBannerSize() -> CGSize {
        if homeMainData.banners.isEmpty {
            return .zero
        } else {
            return CGSize(width: UIScreen.main.bounds.width-CGFloat(32), height: 100)
        }
    }

    func title16BoldSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 21)
    }

    func MainFeedCollectionViewSize() -> CGSize {
        let height: CGFloat = { () -> CGFloat in
            if recommendFeeds.count > 0 {
                let lineCount = round(Double(self.recommendFeeds.count)/2.0)
                var cellHeight: CGFloat = 273 * CGFloat(lineCount)
                if lineCount > 0 { cellHeight += 20 * CGFloat(lineCount-1) }

                return cellHeight
            } else {
                return CGFloat(285)
            }
        }()

        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
    
    func viewMoreButtonSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: recommendFeeds.count >= 12 ? 68 : 0)
    }
    
    func footerSectionSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 99)
    }
}
