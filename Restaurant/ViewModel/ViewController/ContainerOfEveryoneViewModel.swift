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
        RecentlyFeedCollectionView()
    ]
    
    func mostFeedTopTenSize() -> CGSize {
        return CGSize(width: CGFloat(375).widthRatio(), height: 286)
    }
    
    func RecentlyFeedSize() -> CGSize {
        return CGSize(width: CGFloat(375).widthRatio(), height: 108 * 5 + 20 * 4 + 114)
    }
}
