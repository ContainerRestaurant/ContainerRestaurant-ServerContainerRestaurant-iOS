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
    var mainFoodAndContainer: [(String,String)] = [("","")]
    var mainFoodAndContainerSubject: BehaviorSubject<[(String,String)]> = BehaviorSubject<[(String,String)]>(value: [("","")])
    var mainFoodCount: Int = 1
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
            .subscribe(onNext: { [weak self] in
                if self!.mainFoodCount >= 5 {
                    print("더이상 추가 안됨")
                } else {
                    self?.mainFoodAndContainer.append(("",""))
                    self?.mainFoodCount += 1
                    
                    let cardHeight = CGFloat(104 * self!.mainFoodCount)
                    let cardSpacing = CGFloat(14 * (self!.mainFoodCount-1))
                    
                    self?.cardHeightSubject?.onNext(cardHeight+cardSpacing)
                    self?.collectionView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func configure(_ mainFoodAndContainerSubject: BehaviorSubject<[(String,String)]>, _ cardHeightSubject: PublishSubject<CGFloat>, _ foodType: FoodType) {
        self.mainFoodAndContainerSubject = mainFoodAndContainerSubject
        self.cardHeightSubject = cardHeightSubject
        self.foodType = foodType
    }
}

//MARK: - CollectionView Protocol
extension CreationFeedDetail: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainFoodCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CreationFeedDetailCardCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)

        cell.configure(foodType: self.foodType!)
        cell.mainTextField.rx.text
            .subscribe(onNext: { [weak self] mainFood in
                self?.mainFoodAndContainer[indexPath.row].0 = mainFood!
                self?.mainFoodAndContainerSubject.onNext(self!.mainFoodAndContainer)
            })
            .disposed(by: disposeBag)
        cell.subTextField.rx.text
            .subscribe(onNext: { [weak self] container in
                self?.mainFoodAndContainer[indexPath.row].1 = container!
                self?.mainFoodAndContainerSubject.onNext(self!.mainFoodAndContainer)
            })
            .disposed(by: disposeBag)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(343).widthRatio(), height: CGFloat(104))
    }
}
