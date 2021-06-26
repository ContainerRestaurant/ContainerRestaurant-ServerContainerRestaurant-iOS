//
//  FoodCategory.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/03.
//

import UIKit
import RxSwift

class FoodCategory: UICollectionViewCell {
    var category: [(String,String)] = [
        ("KOREAN","한식"),
        ("NIGHT_MEAL","야식"),
        ("CHINESE","중식"),
        ("SCHOOL_FOOD","분식"),
        ("FAST_FOOD","패스트푸드"),
        ("ASIAN_AND_WESTERN","아시안/양식"),
        ("COFFEE_AND_DESSERT","카페/디저트"),
        ("JAPANESE","돈가스/회/일식"),
        ("CHICKEN_AND_PIZZA","치킨/피자")
    ]
    var isClickedArray: [Bool] = Array(repeating: false, count: 9)
    var selectedCategorySubject: PublishSubject<String> = PublishSubject<String>()

    @IBOutlet weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()

        setCollectionView()
        isClickedArray[0] = true
    }

    func configure(_ selectedCategorySubject: PublishSubject<String>) {
        self.selectedCategorySubject = selectedCategorySubject
    }
}

//MARK: - Instance Method
extension FoodCategory {
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(FoodCategoryCollectionViewCell.self)
    }
}

//MARK: - CollectionView Protocol
extension FoodCategory: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FoodCategoryCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(title: category[indexPath.row].1, isClicked: isClickedArray[indexPath.row])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var categoryWidth: CGFloat {
            switch indexPath.row {
            case 0...3: return CGFloat(53)
            case 4: return CGFloat(84)
            case 5...6: return CGFloat(89)
            case 7: return CGFloat(103)
            case 8: return CGFloat(89)
            default: return CGFloat(0)
            }
        }
        return CGSize(width: categoryWidth.widthRatio(), height: CGFloat(32))
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.isClickedArray[indexPath.row] = true
        for (index, _) in isClickedArray.enumerated() {
            if index == indexPath.row {
                self.selectedCategorySubject.onNext(category[indexPath.row].0)
            } else {
                self.isClickedArray[index] = false
            }
        }

        UIView.performWithoutAnimation {
            collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
}
