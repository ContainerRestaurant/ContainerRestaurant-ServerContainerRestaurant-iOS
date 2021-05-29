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
    var cardHeightSubject: PublishSubject<CGFloat> = PublishSubject<CGFloat>()

    init() {
        appendModule()
    }
}

extension CreationFeedViewModel {
    mutating func appendModule() {
        self.modules.append(Title16Bold())
        self.modules.append(CreationFeedDetail())
    }

    func mainTitleSectionSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 24)
    }
    
    func creationFeedDetailSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 500)
    }
}
