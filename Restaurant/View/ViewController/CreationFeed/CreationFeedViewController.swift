//
//  CreationFeedViewController.swift
//  Restaurant
//
//  Created by Lotte on 2021/05/27.
//

import UIKit
import FittedSheets

enum FoodType {
    case main
    case side
}

class CreationFeedViewController: BaseViewController, Storyboard {
    weak var coordinator: CreationFeedCoordinator?
    var viewModel: CreationFeedViewModel!
    var mainFoodHeight: CGFloat = 179
    var sideFoodHeight: CGFloat = 179

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
        self.collectionView.register(CreationFeedDetailSide.self)
    }
    
    private func binding() {
        viewModel.mainFoodHeightSubject
            .subscribe(onNext: { [weak self] cardViewHeight in
                let titleHeight: CGFloat = 20
                let spacing: CGFloat = 16
                let buttonHeight: CGFloat = 20
                
                self?.mainFoodHeight = titleHeight + spacing + cardViewHeight + spacing + buttonHeight
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.sideFoodHeightSubject
            .subscribe(onNext: { [weak self] cardViewHeight in
                let titleHeight: CGFloat = 20
                let spacing: CGFloat = 16
                let buttonHeight: CGFloat = 20
                
                self?.sideFoodHeight = titleHeight + spacing + cardViewHeight + spacing + buttonHeight
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
            cell.configure(self.viewModel.mainFoodHeightSubject, .main)
            return cell
        case is CreationFeedDetailSide:
            let cell: CreationFeedDetailSide = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(self.viewModel.sideFoodHeightSubject, .side)
            return cell
        default: return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0: return viewModel.mainTitleSectionSize()
        case 1: return CGSize(width: UIScreen.main.bounds.width, height: self.mainFoodHeight.ratio())
        case 2: return CGSize(width: UIScreen.main.bounds.width, height: self.sideFoodHeight.ratio())
        default: return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.zero
    }
}
