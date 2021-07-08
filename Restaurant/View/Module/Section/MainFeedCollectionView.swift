//
//  MainFeedCollectionView.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/27.
//

import UIKit

class MainFeedCollectionView: UICollectionViewCell {
    var cells: [UICollectionViewCell] = []
    private var recommendFeeds: [FeedPreviewModel] = []
    private let interItemSpacing: CGFloat = 12
    private let cellLineSpacing: CGFloat = 20
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setCells()
        setCollectionView()
    }
    
    func configure(recommendFeeds: [FeedPreviewModel]) {
        self.recommendFeeds = recommendFeeds
    }
}

//MARK: - Instance Method
extension MainFeedCollectionView {
    private func setCells() {
        self.cells.append(MainFeedCollectionViewCell())
    }
    
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(MainFeedCollectionViewCell.self)
    }
}

//MARK: - CollectionView Protocol
extension MainFeedCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recommendFeeds.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MainFeedCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(self.recommendFeeds[indexPath.row])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = CGFloat(164)
        let cellHeight = CGFloat(273)
        
        return CGSize(width: cellWidth.widthRatio(), height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.interItemSpacing.widthRatio()
    }
}
