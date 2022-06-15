//
//  ViewModelType.swift
//  Restaurant
//
//  Created by 0ofKim on 2022/06/15.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    var disposeBag: DisposeBag { get }

    func transform(input: Input) -> Output?
}
