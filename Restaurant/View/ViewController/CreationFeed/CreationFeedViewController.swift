//
//  CreationFeedViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/27.
//

import UIKit
import RxSwift
import FittedSheets

enum FoodType {
    case main
    case side
}

class CreationFeedViewController: BaseViewController, Storyboard, ViewModelBindableType {
    weak var coordinator: CreationFeedCoordinator?
    var viewModel: CreationFeedViewModel!
    var mainFoodHeight: CGFloat = 179
    var sideFoodHeight: CGFloat = 179

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var closeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()

        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.coordinator?.presenter.tabBarController?.selectedIndex = 0
    }

    func bindViewModel() {
        viewModel.restaurantNameSubject
            .subscribe(onNext: { [weak self] in
                self?.viewModel.restaurantName = $0
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)

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

    deinit {
        print("CreationFeedViewController Deinit")
    }
}

//MARK: - Instance Method
extension CreationFeedViewController {
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.register(SeparateLineCollectionViewCell.self)
        self.collectionView.register(Title16Bold.self)
        self.collectionView.register(SearchRestaurant.self)
        self.collectionView.register(FoodCategory.self)
        self.collectionView.register(CreationFeedDetail.self)
        self.collectionView.register(CreationFeedDetailSide.self)
        self.collectionView.register(LevelOfDifficultyAndWelcome.self)
        self.collectionView.register(CreationFeedImage.self)
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
        case is SeparateLineCollectionViewCell:
            let cell: SeparateLineCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            if indexPath.row == 0 {
                cell.configureCell(height: CGFloat(21), color: .white)
            } else if indexPath.row == 3 {
                cell.configureCell(height: CGFloat(36), color: .white)
            } else if indexPath.row == 5 {
                cell.configureCell(height: CGFloat(12), color: .white)
            } else if indexPath.row == 7 {
                cell.configureCell(height: CGFloat(34), color: .white)
            } else if indexPath.row == 8 {
                cell.configureCell(height: CGFloat(8), color: .colorGrayGray02)
            } else if indexPath.row == 9 {
                cell.configureCell(height: CGFloat(34), color: .white)
            } else if indexPath.row == 11 {
                cell.configureCell(height: CGFloat(12), color: .white)
            } else if indexPath.row == 13 {
                cell.configureCell(height: CGFloat(32), color: .white)
            } else if indexPath.row == 16 {
                cell.configureCell(height: CGFloat(8), color: .colorGrayGray02)
            }
            return cell

        case is Title16Bold:
            let cell: Title16Bold = collectionView.dequeueReusableCell(for: indexPath)
            if indexPath.row == 1 {
                cell.configure(title: "식당 이름")
            } else if indexPath.row == 4 {
                cell.configure(title: "음식 카테고리")
            } else if indexPath.row == 10 {
                cell.configure(title: "상세 내역")
            }
            return cell

        case is SearchRestaurant:
            let cell: SearchRestaurant = collectionView.dequeueReusableCell(for: indexPath)
            if let coordinator = self.coordinator {
                cell.configure(coordinator, viewModel.restaurantNameSubject)
            }
            return cell

        case is FoodCategory:
            let cell: FoodCategory = collectionView.dequeueReusableCell(for: indexPath)
            return cell

        case is CreationFeedDetail:
            let cell: CreationFeedDetail = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(self.viewModel.mainFoodHeightSubject, .main)
            return cell

        case is CreationFeedDetailSide:
            let cell: CreationFeedDetailSide = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(self.viewModel.sideFoodHeightSubject, .side)
            return cell

        case is LevelOfDifficultyAndWelcome:
            let cell: LevelOfDifficultyAndWelcome = collectionView.dequeueReusableCell(for: indexPath)
            return cell

        case is CreationFeedImage:
            let cell: CreationFeedImage = collectionView.dequeueReusableCell(for: indexPath)
            if let coordinator = self.coordinator {
                cell.configure(coordinator)
            }
            return cell

        default: return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0: return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(21))
        case 1: return viewModel.mainTitleSectionSize()
        case 2: return viewModel.searchRestaurantSize()
        case 3: return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(36))
        case 4: return viewModel.mainTitleSectionSize()
        case 5: return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(12))
        case 6: return viewModel.foodCategorySize()
        case 7: return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(34))
        case 8: return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(8))
        case 9: return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(34))
        case 10: return viewModel.mainTitleSectionSize()
        case 11: return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(12))
        case 12: return CGSize(width: UIScreen.main.bounds.width, height: self.mainFoodHeight)
        case 13: return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(32))
        case 14: return CGSize(width: UIScreen.main.bounds.width, height: self.sideFoodHeight)
        case 15: return viewModel.levelOfDifficultyAndWelcomeSize()
        case 16: return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(8))
        case 17: return viewModel.creationFeedImage()
        default: return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat.zero
    }
}
