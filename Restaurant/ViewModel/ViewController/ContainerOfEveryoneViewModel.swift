//
//  ContainerOfEveryoneViewModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/09.
//

import UIKit

class ContainerOfEveryoneViewModel {
    var mostFeedWriters: [UserModel] = []
    var recentlyFeedWriters: [UserModel] = []
    var userCount: Int = 0
    var feedCount: Int = 0
    var modules: [UICollectionViewCell.Type] = []

    init(_ containerOfEveryoneData: ContainerOfEveryoneModel) {
        self.mostFeedWriters = containerOfEveryoneData.mostFeedWriters
        self.recentlyFeedWriters = containerOfEveryoneData.recentlyFeedWriters
        self.userCount = containerOfEveryoneData.writerCount
        self.feedCount = containerOfEveryoneData.feedCount

        setModule()
    }

    private func setModule() {
        if self.mostFeedWriters.count > 0 {
            self.modules.append(MostFeedCreationUserCollectionView.self)
        }
        self.modules.append(RecentlyFeedCreationUserCollectionView.self)
    }
    
    func mostFeedTopTenSize() -> CGSize {
        return CGSize(width: CGFloat(375).widthRatio(), height: 286)
    }
    
    func RecentlyFeedSize() -> CGSize {
        let lineCount = self.recentlyFeedWriters.count/4 + 1
        let userCellHeight = CGFloat(108 * lineCount)
        let spacingHeight = CGFloat(20 * (lineCount-1))
        let topHeight = CGFloat(114)
        return CGSize(width: CGFloat(375).widthRatio(), height: topHeight + userCellHeight + spacingHeight)
    }
}
