//
//  RecentlyFeedCreationUserCollectionView.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/09.
//

import UIKit

class RecentlyFeedCreationUserCollectionView: UICollectionViewCell {
    weak var coordinator: ContainerOfEveryoneCoordinator?
    var recentlyFeedCreationUsers: [UserModel] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var writerStatisticsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCollectionView()

        print("RecentlyFeedCreationUserCollectionView awakeFromNib()")
    }
    
    deinit {
        print("RecentlyFeedCreationUserCollectionView Deinit")
    }

    func configure(_ recentlyFeedCreationUsers: [UserModel],_ writerCount: Int, _ feedCount: Int, _ coordinator: ContainerOfEveryoneCoordinator) {
        self.recentlyFeedCreationUsers = recentlyFeedCreationUsers
        writerStatisticsLabel.text = "지금까지 총 \(writerCount)명이 \(feedCount)번의 용기를 내주셨어요!"
        self.coordinator = coordinator
    }
}

//MARK: - Instance Method
extension RecentlyFeedCreationUserCollectionView {
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(RecentlyFeedCreationUserCollectionViewCell.self)
    }
}

//MARK: - CollectionView Protocol
extension RecentlyFeedCreationUserCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recentlyFeedCreationUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RecentlyFeedCreationUserCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(user: self.recentlyFeedCreationUsers[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(74).widthRatio(), height: 108)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.pushToInquiryProfile()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(20).widthRatio()
    }
}
