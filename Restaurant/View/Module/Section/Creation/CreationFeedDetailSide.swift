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
    var sideFoodAndContainer: [(String,String)] = [("","")]
    var sideFoodAndContainerSubject: BehaviorSubject<[(String,String)]> = BehaviorSubject<[(String,String)]>(value: [("","")])
    var subFoodCount: Int = 1
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
extension CreationFeedDetailSide {
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(CreationFeedDetailCardCollectionViewCell.self)
    }
    
    private func bindingView() {
        appendFoodButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if self!.subFoodCount >= 5 {
                    print("더이상 추가 안됨")
                } else {
                    self?.sideFoodAndContainer.append(("",""))
                    self?.subFoodCount += 1
                    
                    let cardHeight = CGFloat(104 * self!.subFoodCount)
                    let cardSpacing = CGFloat(14 * (self!.subFoodCount-1))
                    
                    self?.cardHeightSubject?.onNext(cardHeight+cardSpacing)
                    self?.collectionView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func configure(_ sideFoodAndContainerSubject: BehaviorSubject<[(String,String)]>, _ cardHeightSubject: PublishSubject<CGFloat>, _ foodType: FoodType) {
        self.sideFoodAndContainerSubject = sideFoodAndContainerSubject
        self.cardHeightSubject = cardHeightSubject
        self.foodType = foodType
    }
}

//MARK: - CollectionView Protocol
extension CreationFeedDetailSide: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subFoodCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CreationFeedDetailCardCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)

        cell.configure(foodType: foodType!)
        cell.mainTextField.rx.text
            .subscribe(onNext: { [weak self] sideFood in
                self?.sideFoodAndContainer[indexPath.row].0 = sideFood!
                self?.sideFoodAndContainerSubject.onNext(self!.sideFoodAndContainer)
            })
            .disposed(by: disposeBag)
        cell.subTextField.rx.text
            .subscribe(onNext: { [weak self] container in
                self?.sideFoodAndContainer[indexPath.row].1 = container!
                self?.sideFoodAndContainerSubject.onNext(self!.sideFoodAndContainer)
            })
            .disposed(by: disposeBag)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(343).widthRatio(), height: CGFloat(104))
    }
}
