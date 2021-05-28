//
//  CreationFeedViewModel.swift
//  Restaurant
//
//  Created by Lotte on 2021/05/27.
//

import UIKit

struct CreationFeedViewModel {
    var modules: [UICollectionViewCell] = []

    init() {
        appendModule()
    }
}

extension CreationFeedViewModel {
    mutating func appendModule() {
        self.modules.append(Title16Bold())
    }

    func mainTitleSectionSize() -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 24)
    }
}
