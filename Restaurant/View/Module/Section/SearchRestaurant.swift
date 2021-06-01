//
//  SearchRestaurant.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/30.
//

import UIKit
import RxSwift
import FittedSheets

class SearchRestaurant: UICollectionViewCell {
    let disposeBag = DisposeBag()
    weak var coordinator: CreationFeedCoordinator?
    weak var searchRestaurantSubejct: PublishSubject<String>? //아직 안씀

    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var searchRestaurantButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        searchRestaurantButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.presentBottomSheet()
            })
            .disposed(by: disposeBag)
    }

    func configure(_ coordinator: CreationFeedCoordinator, _ searchResataurantSubject: PublishSubject<String>) {
        self.coordinator = coordinator
        self.searchRestaurantSubejct = searchResataurantSubject //아직 안씀
    }
}

//MARK: - Instance Method
extension SearchRestaurant {
    private func presentBottomSheet() {
        let searchRestaurant = SearchRestaurantViewController.instantiate()
        let sheetViewController = SheetViewController(controller: searchRestaurant,
//                                                      sizes: [.fixed(150), .marginFromTop(200)],
                                                      sizes: [.marginFromTop(100)],
                                                      options: SheetOptions(
                                                        useFullScreenMode: false,
                                                        shrinkPresentingViewController: false))
        sheetViewController.dismissOnPull = true
        sheetViewController.cornerRadius = 24
        sheetViewController.gripColor = .colorGrayGray04
        sheetViewController.gripSize = CGSize(width: CGFloat(32).ratio(), height: 4)
        sheetViewController.didDismiss = { _ in
            print("sheetViewController didDismiss")
        }
        if sheetViewController.shouldRecognizePanGestureWithUIControls {
            print("pan 시작")
        }
        Common.currentViewController()?.present(sheetViewController, animated: true, completion: nil)
    }
}
