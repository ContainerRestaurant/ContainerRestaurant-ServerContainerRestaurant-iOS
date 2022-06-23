//
//  FeedViewModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/07.
//

import UIKit
import RxCocoa

class FeedViewModel {
    var categoryFeeds: [FeedPreviewModel] = []
    var totalPage: Int = 0
    var currentPage: Int = 0
    var selectedSortIndex: Int = 0
    var selectedCategoryIndex: Int = 0
    var ableAddPage = true
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

    func sortString() -> String {
        switch selectedSortIndex {
        case 1: return "likeCount,DESC"
        case 2: return "difficulty,ASC"
        case 3: return "difficulty,DESC"
        default: return ""
        }
    }

    func categoryLabelSize(_ index: Int) -> CGSize {
        let label = PaddingLabel(frame: CGRect.zero)
        label.font = selectedCategoryIndex == index ? .boldSystemFont(ofSize: 16) : .systemFont(ofSize: 16)
        label.paddingLeft = 10
        label.paddingRight = 10
        label.text = category[index].1
        label.sizeToFit()

        return CGSize(width: label.frame.width.widthRatio(), height: 47)
    }

    func sortLabelSize(_ index: Int) -> CGSize {
        let label = PaddingLabel(frame: .zero)
        label.font = selectedSortIndex == index ? .boldSystemFont(ofSize: 14) : .systemFont(ofSize: 14)
        label.paddingLeft = 10
        label.paddingRight = 10
        switch index {
        case 0: label.text = "최신 순"
        case 1: label.text = "좋아요 많은 순"
        case 2: label.text = "난이도 낮은 순"
        case 3: label.text = "난이도 높은 순"
        default: break
        }
        label.sizeToFit()
        return CGSize(width: label.frame.width.widthRatio(), height: 56)
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
