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
    var restaurantNameSubject: BehaviorSubject<String>?

    init(_ subeject: BehaviorSubject<String>) {
        self.restaurantNameSubject = subeject
    }
}
