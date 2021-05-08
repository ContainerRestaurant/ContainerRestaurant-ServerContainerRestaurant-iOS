//
//  HomeViewModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/10.
//

import UIKit

struct HomeViewModel {
    var modules: [UICollectionViewCell] = [
        MainTitleSection(),
        Title16Bold(),
        MainFeedCollectionView()
    ]
    
    init() {
    }
    
    func mainTitleSectionSize() -> CGSize {
        return CGSize(width: 375, height: 251)
    }
    
    func title16BoldSize() -> CGSize {
        return CGSize(width: 375, height: 21)
    }
    
    func MainFeedCollectionViewSize() -> CGSize {
        let width: CGFloat = 375
        let height: CGFloat = { () -> CGFloat in
            let line = round(9.0/2.0) //9 => dummyNumber
            let cellHeight: CGFloat = 273 * CGFloat(line)
            let spacingHeight: CGFloat = 20 * CGFloat(line-1)
            
            return cellHeight + spacingHeight
        }()
        
        return CGSize(width: width, height: height)
    }
}
