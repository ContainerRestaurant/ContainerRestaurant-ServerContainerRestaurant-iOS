//
//  MyContentsCollectionView.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/02.
//

import UIKit

class MyContentsCollectionView: UICollectionViewCell {
    private var cells: [UICollectionViewCell] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCells()
        setCollectionView()
    }
    
//    func configure() {
//
//    }
}

//MARK: - Instance Method
extension MyContentsCollectionView {
    private func setCells() {
        self.cells.append(MyContentsCollectionViewCell())
    }
    
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(MyContentsCollectionViewCell.self)
    }
}

//MARK: - CollectionView Protocol
extension MyContentsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var (imageName, title) : (String, String) = ("","")
        
        switch indexPath.row {
        case 0: (imageName, title) = ("iconFeedFilled20Px", "내 피드")
        case 1: (imageName, title) = ("iconBookmarkFilled20Px", "스크랩한 피드")
        case 2: (imageName, title) = ("iconFavoriteFilled20Px", "찜한 식당")
        default: break
        }
        
        let cell: MyContentsCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configureCell(imageName: imageName, title: title)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 375, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.zero
    }
}
