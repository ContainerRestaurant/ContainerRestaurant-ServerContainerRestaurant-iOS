//
//  MyViewModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/16.
//

import Foundation
import RxSwift
import RxCocoa

struct MyViewModel {
    var viewModel: UserModel

    lazy var nickname: Driver<String> = {
        return Driver<String>.just(viewModel.nickname)
    }()
    
    lazy var levelTitle: Driver<String> = {
        return Driver<String>.just(viewModel.levelTitle)
    }()
    
    lazy var feedCount: Driver<Int> = {
        return Driver<Int>.just(viewModel.feedCount)
    }()
    
    lazy var scrapFeedCount: Driver<Int> = {
        return Driver<Int>.just(viewModel.scrapCount)
    }()
    
    lazy var bookmarkedCount: Driver<Int> = {
        return Driver<Int>.just(viewModel.bookmarkedCount)
    }()
    
    init(viewModel: UserModel) {
        self.viewModel = viewModel
    }
}
