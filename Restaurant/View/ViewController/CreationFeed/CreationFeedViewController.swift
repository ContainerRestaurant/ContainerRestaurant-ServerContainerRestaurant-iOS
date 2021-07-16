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
    let registerSubject: PublishSubject<Bool> = PublishSubject<Bool>()

//    var restaurantNameLabel: UILabel?
    var restaurant: LocalSearchItem?
    var selectedCategory: String = "KOREAN"
    var selectedCategorySubject: PublishSubject<String> = PublishSubject<String>()
    var mainFoodAndContainer: [FoodAndContainerModel] = []
    var mainFoodAndContainerSubject: PublishSubject<[FoodAndContainerModel]> = PublishSubject<[FoodAndContainerModel]>()
    var sideFoodAndContainer: [FoodAndContainerModel] = []
    var sideFoodAndContainerSubject: PublishSubject<[FoodAndContainerModel]> = PublishSubject<[FoodAndContainerModel]>()
    var levelOfDifficulty: Int = 1
    var levelOfDifficultySubject: PublishSubject<Int> = PublishSubject<Int>()
    var isWelcome: Bool = false
    var isWelcomeSubject: PublishSubject<Bool> = PublishSubject<Bool>()
    var imageID: Int?
    var imageIDSubject: PublishSubject<Int> = PublishSubject<Int>()
    var imageSubject: PublishSubject<UIImage> = PublishSubject<UIImage>()
    var contentsTextSubject: PublishSubject<String> = PublishSubject<String>()
    var contentsText: String = ""

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var closeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()

        viewModel.restaurantSubject
            .subscribe(onNext: { [weak self] in
                self?.restaurant = $0
            })
            .disposed(by: disposeBag)
        
        selectedCategorySubject
            .subscribe(onNext: { [weak self] in
                self?.selectedCategory = $0
            })
            .disposed(by: disposeBag)

        mainFoodAndContainerSubject
            .subscribe(onNext: { [weak self] in
                self?.mainFoodAndContainer = $0
            })
            .disposed(by: disposeBag)

        sideFoodAndContainerSubject
            .subscribe(onNext: { [weak self] in
                self?.sideFoodAndContainer = $0
            })
            .disposed(by: disposeBag)

        levelOfDifficultySubject
            .subscribe(onNext: { [weak self] in
                self?.levelOfDifficulty = $0
            })
            .disposed(by: disposeBag)

        isWelcomeSubject
            .subscribe(onNext: { [weak self] in
                self?.isWelcome = $0
            })
            .disposed(by: disposeBag)
        
        imageSubject
            .subscribe(onNext: { [weak self] in
                //API쏘기
                API().uploadImage(image: $0, imageIDSubject: self!.imageIDSubject)
            })
            .disposed(by: disposeBag)
        
        imageIDSubject
            .subscribe(onNext: { [weak self] in
                self?.imageID = $0
            })
            .disposed(by: disposeBag)
        
        contentsTextSubject
            .subscribe(onNext: { [weak self] in
                self?.contentsText = $0
            })
            .disposed(by: disposeBag)

//        registerSubject
//            .filter { $0 }
//            .subscribe(onNext: { [weak self] _ in
//                print(self?.restaurantNameLabel?.text)
//                print(self?.selectedCategory)
//                print(self?.mainFoodAndContainer)
//                print(self?.sideFoodAndContainer)
//                print(self?.levelOfDifficulty)
//                print(self?.isWelcome)
//                print(self?.imageID)
////                print(self?.image)
//            })
//            .disposed(by: disposeBag)
        
        //Todo: 현재는 사진 입력됐을 때에만 등록됨... => 사진은 옵셔널로 수정 ㄱ
        Observable
            .zip(registerSubject, imageIDSubject)
            .subscribe(onNext: { [weak self] (registerSubject, imageIDSubject) in
                let convertingXY = self?.convertingXY()
                let restaurant: RestaurantModel = RestaurantModel(name: self?.restaurant?.title.deleteBrTag() ?? "", address: self?.restaurant?.roadAddress ?? "", latitude: convertingXY?.lat ?? 0.0, longitude: convertingXY?.lng ?? 0.0)
                
                if let mainFoodAndContainer = self?.mainFoodAndContainer,
                   let sideFoodAndContainer = self?.sideFoodAndContainer,
                   let thumbnailImageID = self?.imageID,
                   let coordinator = self?.coordinator {
                    let feedInformation = FeedModel(restaurantCreateDto: restaurant, category: self!.selectedCategory, mainMenu: mainFoodAndContainer, subMenu: sideFoodAndContainer, difficulty: self!.levelOfDifficulty, welcome: self!.isWelcome, thumbnailImageID: thumbnailImageID, content: self!.contentsText)
                    
                    API().uploadFeed(feedModel: feedInformation, coordinator: coordinator)
                }
            })
            .disposed(by: disposeBag)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.coordinator?.presenter.tabBarController?.selectedIndex = 0
    }

    func bindingView() {
//        viewModel.restaurantNameSubject
//            .subscribe(onNext: { [weak self] in
//                self?.viewModel.restaurantName = $0
//                self?.collectionView.reloadData()
//            })
//            .disposed(by: disposeBag)

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

        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
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
        if let mapx = self.restaurant?.mapx,
           let mapy = self.restaurant?.mapy {
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
            if indexPath.row == 0 {
                cell.configureCell(height: CGFloat(16), color: .white)
            } else if indexPath.row == 3 {
                cell.configureCell(height: CGFloat(34), color: .white)
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

        case is Title16Bold.Type:
            let cell: Title16Bold = collectionView.dequeueReusableCell(for: indexPath)
            if indexPath.row == 1 {
                cell.configure(title: "식당 이름")
            } else if indexPath.row == 4 {
                cell.configure(title: "음식 카테고리")
            } else if indexPath.row == 10 {
                cell.configure(title: "상세 내역")
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
            cell.configure(self.selectedCategorySubject)
            return cell

        case is CreationFeedDetail.Type:
            let cell: CreationFeedDetail = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(self.mainFoodAndContainerSubject, self.viewModel.mainFoodHeightSubject, .main)
            return cell

        case is CreationFeedDetailSide.Type:
            let cell: CreationFeedDetailSide = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(self.sideFoodAndContainerSubject, self.viewModel.sideFoodHeightSubject, .side)
            return cell

        case is LevelOfDifficultyAndWelcome.Type:
            let cell: LevelOfDifficultyAndWelcome = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(self.levelOfDifficultySubject, self.isWelcomeSubject)

            return cell

        case is CreationFeedImage.Type:
            let cell: CreationFeedImage = collectionView.dequeueReusableCell(for: indexPath)
            if let coordinator = self.coordinator {
                cell.configure(coordinator, registerSubject, imageSubject, contentsTextSubject)
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
}
