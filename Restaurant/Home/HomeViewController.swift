//
//  HomeViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/04.
//

import UIKit

class HomeViewController: BaseViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        setCollectionView()
    }
}

extension HomeViewController {
    func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(UINib(nibName: "MainTitleSection", bundle: .main), forCellWithReuseIdentifier: "MainTitleSection")
        collectionView.register(UINib(nibName: "Title16Bold", bundle: .main), forCellWithReuseIdentifier: "Title16Bold")
        collectionView.register(UINib(nibName: "MainFeedCollectionView", bundle: .main), forCellWithReuseIdentifier: "MainFeedCollectionView")

    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        if indexPath.row == 0 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainTitleSection", for: indexPath)
        } else if indexPath.row == 1 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Title16Bold", for: indexPath)
        } else if indexPath.row == 2 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainFeedCollectionView", for: indexPath)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 2 { return CGSize(width: 375, height: 4095) }
//        return CGSize(width: 375, height: 233)
        return CGSize(width: 375, height: 50)
    }
}
