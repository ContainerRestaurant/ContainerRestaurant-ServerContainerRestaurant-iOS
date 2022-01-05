//
//  FeedViewModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/07.
//

import UIKit

class FeedViewModel {
    var categoryFeeds: [FeedPreviewModel] = []
    var totalPage: Int = 0
    var currentPage: Int = 0
    var category: [(String,String)] = [
        ("ALL", "전체"),
        ("KOREAN", "한식"),
        ("NIGHT_MEAL", "야식"),
        ("CHINESE", "중식"),
        ("SCHOOL_FOOD", "분식"),
        ("FAST_FOOD", "패스트푸드"),
        ("ASIAN_AND_WESTERN", "아시안/양식"),
        ("COFFEE_AND_DESSERT", "카페/디저트"),
        ("JAPANESE", "돈가스/회/일식"),
        ("CHICKEN_AND_PIZZA", "치킨/피자")
    ]
    
    init(_ twoFeedModel: TwoFeedModel) {
        self.categoryFeeds = twoFeedModel.feedPreviewList
        self.totalPage = twoFeedModel.totalPages
    }
    
    func categoryFeedCollectionViewSize() -> CGSize {
        let height: CGFloat = { () -> CGFloat in
            if self.categoryFeeds.count > 0 {
                let lineCount = round(Double(self.categoryFeeds.count)/2.0)
                var cellHeight: CGFloat = 273 * CGFloat(lineCount)
                if lineCount > 0 { cellHeight += 20 * CGFloat(lineCount-1) }

                return cellHeight
            } else {
                return CGFloat(285)
            }
        }()

        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
}
