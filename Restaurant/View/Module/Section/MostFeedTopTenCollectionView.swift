//
//  MostFeedTopTenCollectionView.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/09.
//

import UIKit

class MostFeedTopTenCollectionView: UICollectionViewCell, ViewModelBindableType {
    var viewModel: MostFeedTopTenViewModel!
    weak var coordinator: ContainerOfEveryoneCoordinator?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewModel = MostFeedTopTenViewModel() //나중에 의존성 주입으로 바꿔야함
        setCollectionView()
    }
    
    func bindViewModel() {
        
    }
    
    deinit {
        print("MostFeedTopTenCollectionView Deinit")
    }
}

//MARK: - Instance Method
extension MostFeedTopTenCollectionView {
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(MostFeedTopTenCollectionViewCell.self)
    }
    
    func configure(coordinator: ContainerOfEveryoneCoordinator) {
        self.coordinator = coordinator
    }
}

//MARK: - CollectionView Protocol
extension MostFeedTopTenCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MostFeedTopTenCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(nickName: "닉네임\(indexPath.row)", level: "레벨\(indexPath.row)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.mostFeedTopTenSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.pushToInquiryProfile()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(4).widthRatio()
    }
}
