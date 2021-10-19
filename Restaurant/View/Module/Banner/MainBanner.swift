//
//  MainBanner.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/18.
//

import UIKit

class MainBanner: UICollectionViewCell {
    var coordinator: HomeCoordinator?
    var bannerList: [BannerInfoModel] = []
    
    @IBOutlet weak var mainBannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!

    override func awakeFromNib() {
        super.awakeFromNib()

        setCollectionView()
    }

    private func setCollectionView() {
        mainBannerCollectionView.delegate = self
        mainBannerCollectionView.dataSource = self

        mainBannerCollectionView.register(MainBannerCollectionViewCell.self)

        mainBannerCollectionView.decelerationRate = .fast
    }
    
    func configure(_ coordinator: HomeCoordinator?, _ bannerList: [BannerInfoModel]) {
        self.coordinator = coordinator
        self.bannerList = bannerList
        
        setPageControl()
    }

    private func setPageControl() {
        pageControl.numberOfPages = bannerList.count
    }
}

extension MainBanner: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MainBannerCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(imageURL: self.bannerList[indexPath.row].bannerURL)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(343).widthRatio(), height: CGFloat(88))
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.presentBannerPopup()
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / self.frame.width)
        self.pageControl.currentPage = page
    }
}
