//
//  RecentlyFeedCollectionView.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/09.
//

import UIKit

class RecentlyFeedCollectionView: UICollectionViewCell, ViewModelBindableType {
    var viewModel: RecentlyFeedViewModel!
    weak var viewController: BaseViewController?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCollectionView()
    }
    
    func bindViewModel() {
        
    }
    
    deinit {
        print("RecentlyFeedCollectionView Deinit")
    }
}

//MARK: - Instance Method
extension RecentlyFeedCollectionView {
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(RecentlyFeedCollectionViewCell.self)
    }
    
    func configure(viewController: BaseViewController) {
        self.viewController = viewController
    }
}

//MARK: - CollectionView Protocol
extension RecentlyFeedCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: RecentlyFeedCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 74, height: 108)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewController?.push(viewController: InquiryProfileViewController())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
