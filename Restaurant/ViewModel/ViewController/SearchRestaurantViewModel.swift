//
//  SearchRestaurantViewModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/02.
//

import Foundation
import RxSwift
import RxCocoa

struct SearchRestaurantViewModel {
    var restaurantSubject: PublishSubject<LocalSearchItem>?

    init(_ subeject: PublishSubject<LocalSearchItem>) {
        self.restaurantSubject = subeject
    }
}
