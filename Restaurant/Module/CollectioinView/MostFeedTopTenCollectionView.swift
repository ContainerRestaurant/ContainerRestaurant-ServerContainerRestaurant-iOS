//
//  MostFeedTopTenCollectionView.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/09.
//

import UIKit

class MostFeedTopTenCollectionView: UICollectionViewCell, ViewModelBindableType {
    var viewModel: MostFeedTopTenViewModel!
    var viewController: BaseViewController?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewModel = MostFeedTopTenViewModel() //나중에 의존성 주입으로 바꿔야함
        setCollectionView()
    }
    
    func bindViewModel() {
        
    }
}

//MARK: - Instance Method
extension MostFeedTopTenCollectionView {
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(MostFeedTopTenCollectionViewCell.self)
//        self.collectionView.register(MostFeedTopTenTitleCollectionViewCell.self)
//        self.collectionView.register(SeparateLineCollectionViewCell.self)
    }
    
    func configure(viewController: BaseViewController) {
        self.viewController = viewController
    }
}

//MARK: - CollectionView Protocol
extension MostFeedTopTenCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.row == 0 {
//            let cell: MostFeedTopTenTitleCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
//            return cell
//        }
        
        let cell: MostFeedTopTenCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(nickName: "닉네임\(indexPath.row)", level: "레벨\(indexPath.row)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        switch indexPath.row {
//        case 0: return viewModel.mostFeedTopTenTitleSize()
//        default: return viewModel.mostFeedTopTenSize()
        return viewModel.mostFeedTopTenSize()
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewController?.push(viewController: InquiryProfileViewController())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}
