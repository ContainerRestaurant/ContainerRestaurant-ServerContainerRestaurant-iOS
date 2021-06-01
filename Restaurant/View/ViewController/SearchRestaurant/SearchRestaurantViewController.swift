//
//  SearchRestaurantViewController.swift
//  Restaurant
//
//  Created by Lotte on 2021/06/01.
//

import UIKit
import Alamofire

class SearchRestaurantViewController: BaseViewController, Storyboard {
    weak var coordinator: SearchRestaurantCoordinator?

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var closeButton: UIButton! //상단 constraint 바꾸기

    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()
        API().searchLocal()
    }
}

//MARK: - Instance Method
extension SearchRestaurantViewController {
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(SearchRestaurantCollectionViewCell.self)
    }
}

//MARK: - CollectionView Protocol
extension SearchRestaurantViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: SearchRestaurantCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(64).ratio())
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}
