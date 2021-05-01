//
//  MainFeedCollectionView.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/27.
//

import UIKit

class MainFeedCollectionView: UICollectionViewCell, ReusableCell {
    var cells: [UICollectionViewCell] = []
    var dummyNumber: Int = 0
    private let interItemSpacing: CGFloat = 12
    private let cellLineSpacing: CGFloat = 20
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setCells()
        setCollectionView()
    }
    
    func configure(dummyNumber: Int) {
        self.dummyNumber = dummyNumber
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
        return self.dummyNumber
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainFeedCollectionViewCell", for: indexPath)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = CGFloat(357/2.0) - self.interItemSpacing
        let cellHeight = CGFloat(273)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.interItemSpacing
    }
}
