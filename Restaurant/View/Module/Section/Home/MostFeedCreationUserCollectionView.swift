//
//  MostFeedCreationUserCollectionView.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/09.
//

import UIKit

class MostFeedCreationUserCollectionView: UICollectionViewCell {
    weak var coordinator: ContainerOfEveryoneCoordinator?
    var mostFeedCreationUsers: [UserModel] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCollectionView()
        print("MostFeedCreationUserCollectionView awakeFromNib()")
    }
    
    deinit {
        print("MostFeedCreationUserCollectionView Deinit")
    }
}

//MARK: - Instance Method
extension MostFeedCreationUserCollectionView {
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(MostFeedCreationUserCollectionViewCell.self)
    }
    
    func configure(_ mostFeedCreationUsers: [UserModel], _ coordinator: ContainerOfEveryoneCoordinator) {
        self.mostFeedCreationUsers = mostFeedCreationUsers
        self.coordinator = coordinator
    }
}

//MARK: - CollectionView Protocol
extension MostFeedCreationUserCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.mostFeedCreationUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MostFeedCreationUserCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(user: mostFeedCreationUsers[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(148).widthRatio(), height: 186)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.pushToInquiryProfile(userID: mostFeedCreationUsers[indexPath.row].id)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(4).widthRatio()
    }
}
