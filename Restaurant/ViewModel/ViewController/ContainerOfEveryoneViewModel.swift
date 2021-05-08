//
//  ContainerOfEveryoneViewModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/09.
//

import UIKit

class ContainerOfEveryoneViewModel {
    var modules: [UICollectionViewCell] = [
        MostFeedTopTenCollectionView(),
        SeparateLineCollectionViewCell(),
        RecentlyFeedCollectionView()
    ]
    
    func mostFeedTopTenSize() -> CGSize {
        return CGSize(width: 375, height: 250)
    }
    
    func separateLineSize() -> CGSize {
        return CGSize(width: 375, height: 8)
    }
    
    func RecentlyFeedSize() -> CGSize {
        return CGSize(width: 375, height: 142 * 6 + 20 * 5 + 114)
    }
}
