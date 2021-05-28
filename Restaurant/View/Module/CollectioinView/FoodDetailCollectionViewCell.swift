//
//  FoodDetailCollectionViewCell.swift
//  Restaurant
//
//  Created by Lotte on 2021/05/27.
//

import UIKit

class FoodDetailCollectionViewCell: UICollectionViewCell {
    var mainFoodCount = 1

    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var foodTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var appendFoodButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        setCollectionView()
    }
}

//MARK: - Instance Method
extension FoodDetailCollectionViewCell {
    func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
}

//MARK: - CollectionView Protocol
extension FoodDetailCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainFoodCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
        //카드 셀 추가해야함
    }
}
