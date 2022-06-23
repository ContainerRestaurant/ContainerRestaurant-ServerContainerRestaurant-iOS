//
//  CreationFeedDetailSide.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/30.
//

import UIKit
import RxSwift

class CreationFeedDetailSide: UICollectionViewCell {
    let disposeBag = DisposeBag()
    var sideMenuAndContainer: [MenuAndContainerModel] = [MenuAndContainerModel()]
    var sideMenuAndContainerSubject: PublishSubject<[MenuAndContainerModel]> = PublishSubject<[MenuAndContainerModel]>()
    var sideMenuCount: Int = 1
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

    deinit {
        print("CreationFeedDetailSide Deinit")
    }
}

//MARK: - Instance Method
extension CreationFeedDetailSide {
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(CreationFeedDetailCardCollectionViewCell.self)
    }
    
    private func bindingView() {
        appendFoodButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                if owner.sideMenuCount >= 5 {
                    print("더이상 추가 안됨")
                } else {
                    owner.sideMenuAndContainer.append(MenuAndContainerModel())
                    owner.sideMenuCount += 1
                    
                    let cardHeight = CGFloat(104 * owner.sideMenuCount)
                    let cardSpacing = CGFloat(14 * (owner.sideMenuCount-1))
                    
                    owner.cardHeightSubject?.onNext(cardHeight+cardSpacing)
                    owner.collectionView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func configure(_ sideMenuAndContainerSubject: PublishSubject<[MenuAndContainerModel]>, _ cardHeightSubject: PublishSubject<CGFloat>, _ foodType: FoodType) {
        self.sideMenuAndContainerSubject = sideMenuAndContainerSubject
        self.cardHeightSubject = cardHeightSubject
        self.foodType = foodType
    }
}

//MARK: - CollectionView Protocol
extension CreationFeedDetailSide: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sideMenuCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CreationFeedDetailCardCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)

        cell.configure(foodType: foodType!)
        cell.mainTextField.rx.text
            .withUnretained(self)
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { (owner, sideMenu) in
                owner.sideMenuAndContainer[indexPath.row].menuName = sideMenu!
                owner.sideMenuAndContainerSubject.onNext(owner.sideMenuAndContainer)
            })
            .disposed(by: disposeBag)
        cell.subTextField.rx.text
            .withUnretained(self)
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { (owner, container) in
                owner.sideMenuAndContainer[indexPath.row].container = container!
                owner.sideMenuAndContainerSubject.onNext(owner.sideMenuAndContainer)
            })
            .disposed(by: disposeBag)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(343).widthRatio(), height: CGFloat(104))
    }
}
