//
//  MenuOnFeedDetail.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/08/16.
//

import UIKit

class MenuOnFeedDetail: UICollectionViewCell {
    var menuAndContainers: [MenuAndContainerModel] = []

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var menuTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()

        setCollectionView()
        self.borderView.applySketchShadow(color: .colorGrayGray08, alpha: 0.15, x: 0, y: 0, blur: 5, spread: 0)
    }

    func mainMenuConfigure(menuAndContainers: [MenuAndContainerModel]) {
        self.menuTitleLabel.text = "메인 음식"
        self.menuAndContainers = menuAndContainers
    }

    func sideMenuConfigure(menuAndContainers: [MenuAndContainerModel]) {
        self.menuTitleLabel.text = "사이드 음식"
        self.menuAndContainers = menuAndContainers
    }

    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.register(MenuOnFeedDetailCollectionViewCell.self)
    }
}

extension MenuOnFeedDetail: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuAndContainers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MenuOnFeedDetailCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(menuAndContainer: menuAndContainers[indexPath.row])
        return cell
    }
}
