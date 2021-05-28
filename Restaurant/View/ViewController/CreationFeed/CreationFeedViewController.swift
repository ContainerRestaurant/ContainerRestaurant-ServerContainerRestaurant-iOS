//
//  CreationFeedViewController.swift
//  Restaurant
//
//  Created by Lotte on 2021/05/27.
//

import UIKit
import FittedSheets

class CreationFeedViewController: BaseViewController, Storyboard {
    weak var coordinator: CreationFeedCoordinator?
    var viewModel: CreationFeedViewModel!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var insertTestButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()

        insertTestButton.rx.tap
            .subscribe(onNext: { [weak self] in
                print("클릭")
                self?.viewModel.modules.append(FoodDetailCollectionViewCell())
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.coordinator?.presenter.tabBarController?.selectedIndex = 0
    }

    deinit {
        print("CreationFeedViewController")
    }
}

//MARK: - Instance Method
extension CreationFeedViewController {
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.register(Title16Bold.self)
//        self.collectionView.register(FoodDetailCollectionViewCell.self)
    }
}

//MARK: - CollectionView Protocol
extension CreationFeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.modules.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = viewModel.modules[indexPath.row]

        switch type {
        case is Title16Bold:
            let cell: Title16Bold = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(title: "상세내역")
            return cell

        default: return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(50))
    }

}
