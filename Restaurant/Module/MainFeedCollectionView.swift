//
//  MainFeedCollectionView.swift
//  Restaurant
//
//  Created by Lotte on 2021/04/27.
//

import UIKit

class MainFeedCollectionView: UICollectionViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setCollectionView()
    }

    func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        collectionView.register(UINib(nibName: "MainFeedCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "MainFeedCollectionViewCell")
    }
}

extension MainFeedCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainFeedCollectionViewCell", for: indexPath)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (375/2) - 5, height: 273)
    }
}
