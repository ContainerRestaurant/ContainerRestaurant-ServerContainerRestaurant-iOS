//
//  TwoFeedInLineCollectionView.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/27.
//

import UIKit
import RxSwift

class TwoFeedInLineCollectionView: UICollectionViewCell {
    private var feeds: [FeedPreviewModel] = []
    private let interItemSpacing: CGFloat = 15
    private let cellLineSpacing: CGFloat = 20
    var selectedCategorySubject: PublishSubject<String>?
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCollectionView()
        print("TwoFeedInLineCollectionView awakeFromNib()")
    }
    
    deinit {
        print("TwoFeedInLineCollectionView Deinit")
    }
    
    override func prepareForReuse() {
        self.disposeBag = DisposeBag()
//        feeds = []
    }
    
    //파라미터 많아지면 configure 따로 분리 필요
    func configure(_ feeds: [FeedPreviewModel], _ selectedCategorySubject: PublishSubject<String> = PublishSubject<String>()) {
        self.feeds = feeds
        self.selectedCategorySubject = selectedCategorySubject
        
        self.selectedCategorySubject?
            .subscribe(onNext: { category in
                APIClient.categoryFeed(category: category) { [weak self] feeds in
                    self?.feeds = feeds
                    self?.collectionView.reloadData()
                }
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Instance Method
extension TwoFeedInLineCollectionView {
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(TwoFeedCollectionViewCell.self)
    }
}

//MARK: - CollectionView Protocol
extension TwoFeedInLineCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.feeds.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TwoFeedCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(self.feeds[indexPath.row])

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
