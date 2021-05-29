//
//  CreationFeedDetail.swift
//  Restaurant
//
//  Created by Lotte on 2021/05/27.
//

import UIKit
import RxSwift

class CreationFeedDetail: UICollectionViewCell {
    var mainFoodCount: Int = 1
    let disposeBag = DisposeBag()
    var cardHeightSubject: PublishSubject<CGFloat>?

    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var appendFoodButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setCollectionView()
        binding()
    }
}

//MARK: - Instance Method
extension CreationFeedDetail {
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(CreationFeedDetailCardCollectionViewCell.self)
    }
    
    private func binding() {
        appendFoodButton.rx.tap
            .subscribe(onNext: { [weak self] in
                if self!.mainFoodCount >= 5 {
                    print("더이상 추가 안됨")
                } else {
                    self?.mainFoodCount += 1
                    
                    let cardHeight = CGFloat(105 * self!.mainFoodCount)
                    let cardSpacing = CGFloat(14 * (self!.mainFoodCount-1))
                    
                    self?.cardHeightSubject?.onNext(cardHeight+cardSpacing)
                    self?.collectionView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func configure(_ cardHeightSubject: PublishSubject<CGFloat>) {
        self.cardHeightSubject = cardHeightSubject
    }
}

//MARK: - CollectionView Protocol
extension CreationFeedDetail: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainFoodCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CreationFeedDetailCardCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(343), height: CGFloat(105))
    }
}
