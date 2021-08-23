//
//  ContainerOfEveryoneViewModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/09.
//

import UIKit

class ContainerOfEveryoneViewModel {
    var mostFeedCreationUsers: [UserModel] = []
    var recentlyFeedCreationUsers: [UserModel] = []
    var modules: [UICollectionViewCell.Type] = []

    init(_ mostFeedCreationUsers: [UserModel], _ recentlyFeedCreationUsers: [UserModel]) {
        self.mostFeedCreationUsers = mostFeedCreationUsers
        self.recentlyFeedCreationUsers = recentlyFeedCreationUsers

        setModule()
    }

    private func setModule() {
        if self.mostFeedCreationUsers.count > 0 {
            self.modules.append(MostFeedCreationUserCollectionView.self)
        }
        self.modules.append(RecentlyFeedCreationUserCollectionView.self)
    }
    
    func mostFeedTopTenSize() -> CGSize {
        return CGSize(width: CGFloat(375).widthRatio(), height: 286)
    }
    
    func RecentlyFeedSize() -> CGSize {
        let lineCount = self.recentlyFeedCreationUsers.count/4 + 1
        let userCellHeight = CGFloat(108 * lineCount)
        let spacingHeight = CGFloat(20 * (lineCount-1))
        let topHeight = CGFloat(114)
        return CGSize(width: CGFloat(375).widthRatio(), height: topHeight + userCellHeight + spacingHeight)
    }
}
