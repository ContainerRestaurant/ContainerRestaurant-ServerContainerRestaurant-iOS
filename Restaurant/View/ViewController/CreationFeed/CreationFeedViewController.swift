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
    var sectionHeight: CGFloat = 179

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
        binding()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.coordinator?.presenter.tabBarController?.selectedIndex = 0
    }

    deinit {
        print("CreationFeedViewController Deinit")
    }
}

//MARK: - Instance Method
extension CreationFeedViewController {
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.register(Title16Bold.self)
        self.collectionView.register(CreationFeedDetail.self)
    }
    
    private func binding() {
        viewModel.cardHeightSubject
            .subscribe(onNext: { [weak self] cardViewHeight in
                let titleHeight: CGFloat = 20
                let spacing: CGFloat = 16
                let buttonHeight: CGFloat = 20
                
                self?.sectionHeight = titleHeight + spacing + cardViewHeight + spacing + buttonHeight
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
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
        case is CreationFeedDetail:
            let cell: CreationFeedDetail = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(self.viewModel.cardHeightSubject)
            return cell
        default: return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0: return viewModel.mainTitleSectionSize()
        case 1: return CGSize(width: UIScreen.main.bounds.width, height: self.sectionHeight.ratio())
        default: return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.zero
    }
}
