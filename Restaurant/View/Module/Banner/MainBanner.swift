//
//  MainBanner.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/18.
//

import UIKit

class MainBanner: UICollectionViewCell {
    @IBOutlet weak var mainBannerCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!

    override func awakeFromNib() {
        super.awakeFromNib()

        setCollectionView()
//        setPageControl()
    }

    private func setCollectionView() {
        mainBannerCollectionView.delegate = self
        mainBannerCollectionView.dataSource = self

        mainBannerCollectionView.register(MainBannerCollectionViewCell.self)

        mainBannerCollectionView.decelerationRate = .fast
    }

//    private func setPageControl() {
//        pageControl
//    }
}

extension MainBanner: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MainBannerCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(testIndex: indexPath.row)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(343).widthRatio(), height: CGFloat(88))
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / self.frame.width)
        self.pageControl.currentPage = page
    }
}
