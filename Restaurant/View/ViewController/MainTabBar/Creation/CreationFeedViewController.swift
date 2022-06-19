//
//  CreationFeedViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/27.
//

import UIKit
import RxSwift
import FittedSheets
import NMapsMap

enum FoodType {
    case main
    case side
}

class CreationFeedViewController: BaseViewController, Storyboard, ViewModelBindableType {
    weak var coordinator: CreationFeedCoordinator?
    var viewModel: CreationFeedViewModel!
    var mainFoodHeight: CGFloat = 179
    var sideFoodHeight: CGFloat = 179
    let registerButtonIndexPath = [IndexPath(row: 17, section: 0)]

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var closeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()

        viewModel.restaurantSubject
            .withUnretained(self)
            .subscribe(onNext: { (owner, restaurant) in
                owner.viewModel.restaurant = restaurant
                owner.collectionView.reloadItems(at: owner.registerButtonIndexPath)
            })
            .disposed(by: disposeBag)
        
        viewModel.selectedCategorySubject
            .withUnretained(self)
            .subscribe(onNext: { (owner, selectedCategory) in
                owner.viewModel.selectedCategory = selectedCategory
            })
            .disposed(by: disposeBag)

        viewModel.mainMenuAndContainerSubject
            .withUnretained(self)
            .subscribe(onNext: { (owner, mainFoodAndContainer) in
                owner.viewModel.mainMenuAndContainer = mainFoodAndContainer
                owner.collectionView.reloadItems(at: owner.registerButtonIndexPath)
            })
            .disposed(by: disposeBag)

        viewModel.sideMenuAndContainerSubject
            .withUnretained(self)
            .subscribe(onNext: { (owner, sideFoodAndContainer) in
                owner.viewModel.sideMenuAndContainer = sideFoodAndContainer
            })
            .disposed(by: disposeBag)

        viewModel.levelOfDifficultySubject
            .withUnretained(self)
            .subscribe(onNext: { (owner, levelOfDifficulty) in
                owner.viewModel.levelOfDifficulty = levelOfDifficulty
            })
            .disposed(by: disposeBag)

        viewModel.isWelcomeSubject
            .withUnretained(self)
            .subscribe(onNext: { (owner, isWelcome) in
                owner.viewModel.isWelcome = isWelcome
            })
            .disposed(by: disposeBag)

        viewModel.reuseImageSubject
            .withUnretained(self)
            .subscribe(onNext: { (owner, image) in
                owner.viewModel.reuseImage = image
            })
            .disposed(by: disposeBag)

        viewModel.imageSubject
            .withUnretained(self)
            .subscribe(onNext: { (owner, image) in
                guard let image = image else {
                    owner.viewModel.imageID = -1
                    owner.viewModel.imageIDFlagSubject.onNext(())
                    return
                }

                API().uploadImage(image: image) { imageID in
                    owner.viewModel.imageID = imageID
                    owner.viewModel.imageIDFlagSubject.onNext(())
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.contentsTextSubject
            .withUnretained(self)
            .subscribe(onNext: { (owner, contentsText) in
                owner.viewModel.contentsText = contentsText
            })
            .disposed(by: disposeBag)

        Observable
            .zip(viewModel.registerSubject, viewModel.imageIDFlagSubject)
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                let convertingXY = owner.convertingXY()
                let restaurant: RestaurantModel = RestaurantModel(name: owner.viewModel.restaurant?.title.deleteBrTag() ?? "", address: owner.viewModel.restaurant?.roadAddress ?? "", latitude: convertingXY?.lat ?? 0.0, longitude: convertingXY?.lng ?? 0.0)

                let mainFoodAndContainer = owner.viewModel.mainMenuAndContainer
                let sideFoodAndContainer = owner.viewModel.sideMenuAndContainer

                if let thumbnailImageID = owner.viewModel.imageID, let coordinator = owner.coordinator {
                    let feedInformation = FeedModel(restaurantCreateDto: restaurant,
                                                    category: owner.viewModel.selectedCategory,
                                                    mainMenu: mainFoodAndContainer,
                                                    subMenu: sideFoodAndContainer,
                                                    difficulty: owner.viewModel.levelOfDifficulty,
                                                    welcome: owner.viewModel.isWelcome,
                                                    thumbnailImageID: thumbnailImageID,
                                                    content: owner.viewModel.contentsText)

                    coordinator.confirmCreationFeedPopup(feedModel: feedInformation)
                }
            })
            .disposed(by: disposeBag)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.coordinator?.presenter.tabBarController?.selectedIndex = 0
        disposeBag = DisposeBag()
    }

    func bindingView() {
        viewModel.mainFoodHeightSubject
            .withUnretained(self)
            .subscribe(onNext: { (owner, cardViewHeight) in
                let titleHeight: CGFloat = 20
                let spacing: CGFloat = 16
                let buttonHeight: CGFloat = 20

                owner.mainFoodHeight = titleHeight + spacing + cardViewHeight + spacing + buttonHeight
                owner.collectionView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.sideFoodHeightSubject
            .withUnretained(self)
            .subscribe(onNext: { (owner, cardViewHeight) in
                let titleHeight: CGFloat = 20
                let spacing: CGFloat = 16
                let buttonHeight: CGFloat = 20

                owner.sideFoodHeight = titleHeight + spacing + cardViewHeight + spacing + buttonHeight
                owner.collectionView.reloadData()
            })
            .disposed(by: disposeBag)

        closeButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { (owner, _) in
                if !(owner.viewModel.restaurant?.title.isEmpty ?? true) || !(owner.viewModel.mainMenuAndContainer.first?.menuName.isEmpty ?? true) || !(owner.viewModel.mainMenuAndContainer.first?.container.isEmpty ?? true) || !(owner.viewModel.contentsText.isEmpty) {
                    let confirmExitPopup = CommonPopupViewController.instantiate()
                    confirmExitPopup.isTwoButton = true
                    confirmExitPopup.buttonType = .confirmExit
                    confirmExitPopup.modalPresentationStyle = .overFullScreen
                    Common.currentViewController()?.present(confirmExitPopup, animated: false, completion: nil)
                } else {
                    owner.dismiss(animated: true, completion: nil)
                }
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
    
    private func convertingXY() -> NMGLatLng? {
        if let mapx = self.viewModel.restaurant?.mapx,
           let mapy = self.viewModel.restaurant?.mapy {
            let doubleMapx = Double(mapx)!
            let doubleMapy = Double(mapy)!
            print("변환: \(NMGTm128(x: doubleMapx, y: doubleMapy).toLatLng())")
            return NMGTm128(x: doubleMapx, y: doubleMapy).toLatLng()
        }
        
        return nil
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
        case is SeparateLineCollectionViewCell.Type:
            let cell: SeparateLineCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)

            switch indexPath.row {
            case 0: cell.configureCell(height: CGFloat(16), color: .white)
            case 3: cell.configureCell(height: CGFloat(34), color: .white)
            case 5: cell.configureCell(height: CGFloat(12), color: .white)
            case 7: cell.configureCell(height: CGFloat(34), color: .white)
            case 8: cell.configureCell(height: CGFloat(8), color: .colorGrayGray02)
            case 9: cell.configureCell(height: CGFloat(34), color: .white)
            case 11: cell.configureCell(height: CGFloat(12), color: .white)
            case 13: cell.configureCell(height: CGFloat(32), color: .white)
            case 16: cell.configureCell(height: CGFloat(8), color: .colorGrayGray02)
            default: break
            }

            return cell

        case is Title16Bold.Type:
            let cell: Title16Bold = collectionView.dequeueReusableCell(for: indexPath)

            switch indexPath.row {
            case 1: cell.configure(title: "식당 이름")
            case 4: cell.configure(title: "음식 카테고리")
            case 10: cell.configure(title: "상세 내역")
            default: break
            }

            return cell

        case is SearchRestaurant.Type:
            let cell: SearchRestaurant = collectionView.dequeueReusableCell(for: indexPath)
            if let coordinator = self.coordinator {
                cell.configure(coordinator, viewModel.restaurantSubject)
//                self.restaurantNameLabel = cell.restaurantNameLabel
            }
            return cell

        case is FoodCategory.Type:
            let cell: FoodCategory = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(viewModel.selectedCategorySubject)
            return cell

        case is CreationFeedDetail.Type:
            let cell: CreationFeedDetail = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(viewModel.mainMenuAndContainerSubject, viewModel.mainFoodHeightSubject, .main)
            return cell

        case is CreationFeedDetailSide.Type:
            let cell: CreationFeedDetailSide = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(viewModel.sideMenuAndContainerSubject, viewModel.sideFoodHeightSubject, .side)
            return cell

        case is LevelOfDifficultyAndWelcome.Type:
            let cell: LevelOfDifficultyAndWelcome = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(viewModel.levelOfDifficultySubject, viewModel.isWelcomeSubject)
            return cell

        case is CreationFeedImage.Type:
            let cell: CreationFeedImage = collectionView.dequeueReusableCell(for: indexPath)
            if let coordinator = coordinator {
                cell.configure(coordinator, viewModel)
            }
            return cell

        default: return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0: return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(16))
        case 1: return viewModel.mainTitleSectionSize()
        case 2: return viewModel.searchRestaurantSize()
        case 3: return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(34))
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

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
