//
//  CreationFeedDetail.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/27.
//

import UIKit
import RxSwift

class CreationFeedDetail: UICollectionViewCell {
    let disposeBag = DisposeBag()
    var mainMenuAndContainer: [MenuAndContainerModel] = [MenuAndContainerModel()]
    var mainMenuAndContainerSubject: PublishSubject<[MenuAndContainerModel]> = PublishSubject<[MenuAndContainerModel]>()
    var mainMenuCount: Int = 1
    var cardHeightSubject: PublishSubject<CGFloat>?
    var foodType: FoodType?

    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var appendFoodButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setCollectionView()
        bindingView()
    }
}

//MARK: - Instance Method
extension CreationFeedDetail {
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(CreationFeedDetailCardCollectionViewCell.self)
    }
    
    private func bindingView() {
        appendFoodButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                if owner.mainMenuCount >= 5 {
                    print("더이상 추가 안됨")
                } else {
                    owner.mainMenuAndContainer.append(MenuAndContainerModel())
                    owner.mainMenuCount += 1
                    
                    let cardHeight = CGFloat(104 * owner.mainMenuCount)
                    let cardSpacing = CGFloat(14 * (owner.mainMenuCount-1))
                    
                    owner.cardHeightSubject?.onNext(cardHeight+cardSpacing)
                    owner.collectionView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }

    func configure(_ viewModel: CreationFeedViewModel, _ foodType: FoodType) {
        mainMenuAndContainerSubject = viewModel.mainMenuAndContainerSubject
        cardHeightSubject = viewModel.mainMenuHeightSubject
        self.foodType = foodType
    }
}

//MARK: - CollectionView Protocol
extension CreationFeedDetail: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainMenuCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CreationFeedDetailCardCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)

        cell.configure(foodType: foodType!)
        cell.mainTextField.rx.text
            .withUnretained(self)
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { (owner, mainMenu) in
                owner.mainMenuAndContainer[indexPath.row].menuName = mainMenu!
                owner.mainMenuAndContainerSubject.onNext(owner.mainMenuAndContainer)
            })
            .disposed(by: disposeBag)
        cell.subTextField.rx.text
            .withUnretained(self)
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { (owner, container) in
                owner.mainMenuAndContainer[indexPath.row].container = container!
                owner.mainMenuAndContainerSubject.onNext(owner.mainMenuAndContainer)
            })
            .disposed(by: disposeBag)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(343).widthRatio(), height: CGFloat(104))
    }
}
