//
//  SearchRestaurantViewModel.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/02.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchRestaurantViewModel: ViewModelType {
    weak var coordinator: SearchRestaurantCoordinator?
    var disposeBag = DisposeBag()

    var restaurantSubject: PublishSubject<LocalSearchItem>?
    var items: [LocalSearchItem]?

    init(_ subeject: PublishSubject<LocalSearchItem>, _ coordinator: SearchRestaurantCoordinator?) {
        self.restaurantSubject = subeject
        self.coordinator = coordinator
    }

    deinit {
        print("SearchRestaurantViewModel Deinit")
    }

    struct Input {
        let textField: ControlProperty<String?>
        let closeTap: ControlEvent<Void>
        let textClearTap: ControlEvent<Void>
    }

    struct Output {
        let clearTextField: Driver<String>
        let collectionViewReload: Driver<Void>
    }

    func transform(input: Input) -> Output? {
        let searchLocalSubject = PublishSubject<LocalSearch>()
        let clearTextFieldRelay = PublishRelay<String>()
        let collectionViewReloadRelay = PublishRelay<Void>()

        input.textField
            .subscribe(onNext: {
                API().localSearch(text: $0 ?? "", subject: searchLocalSubject)
            })
            .disposed(by: disposeBag)

        searchLocalSubject
            .withUnretained(self)
            .subscribe(onNext: { (owner, localData) in
                owner.items = localData.items
                collectionViewReloadRelay.accept(())
            })
            .disposed(by: disposeBag)

        input.closeTap
            .subscribe(onNext: {
                Common.currentViewController()?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)

        input.textClearTap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                owner.items = []
                clearTextFieldRelay.accept("")
                collectionViewReloadRelay.accept(())
            })
            .disposed(by: disposeBag)

        return Output(clearTextField: clearTextFieldRelay.asDriver(onErrorJustReturn: ""),
                      collectionViewReload: collectionViewReloadRelay.asDriver(onErrorJustReturn: ()))
    }
}
