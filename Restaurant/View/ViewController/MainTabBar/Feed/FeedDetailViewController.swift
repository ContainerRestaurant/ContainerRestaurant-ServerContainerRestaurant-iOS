//
//  FeedDetailViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/14.
//

import UIKit
import RxSwift

enum FeedDetailTap {
    case information
    case content
}

class FeedDetailViewController: BaseViewController, Storyboard, ViewModelBindableType {
    var viewModel: FeedDetailViewModel!
    weak var coordinator: FeedDetailCoordinator?
    var selectedTapTypeSubject = PublishSubject<FeedDetailTap>()
    var selectedTapType: FeedDetailTap = .information
    var isMainMenu = true

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()

        if viewModel.content.isEmpty {
            selectedTapType = .information
            viewModel.setInformationModules()
        } else {
            selectedTapType = .content
            viewModel.setContentModules()
        }

        selectedTapTypeSubject
            .subscribe(onNext: { [weak self] type in
                self?.selectedTapType = type

                switch type {
                case .information: self?.viewModel.setInformationModules()
                case .content: self?.viewModel.setContentModules()
                }

                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)

        print("FeedDetailViewController viewDidLoad()")
    }
    
    deinit {
        print("FeedDetailViewController Deinit")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigation()
    }
    
    func bindingView() {
        print("FeedDetail bindingView()")
    }
}

//MARK: - Instance Method
extension FeedDetailViewController {
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.register(TopSectionOnFeedDetail.self)
        self.collectionView.register(TapOnFeedDetail.self)
        self.collectionView.register(RestaurantInformationOnFeedDetail.self)
        self.collectionView.register(LevelOfDifficultyOnFeedDetail.self)
        self.collectionView.register(MenuOnFeedDetail.self)

        self.collectionView.register(ContentOnFeedDetail.self)
    }
    
    private func setNavigation() {
        let backImage = UIImage(named: "chevronLeftOutline20Px")
        self.coordinator?.presenter.navigationBar.backIndicatorImage = backImage
        self.coordinator?.presenter.navigationBar.backIndicatorTransitionMaskImage = backImage
        
        self.coordinator?.presenter.navigationBar.barTintColor = .white
        self.coordinator?.presenter.navigationBar.tintColor = .colorGrayGray08
        self.coordinator?.presenter.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.colorGrayGray08]
        self.coordinator?.presenter.navigationBar.isTranslucent = false
        self.coordinator?.presenter.navigationBar.topItem?.title = ""
    }
}

extension FeedDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.modules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.modules[indexPath.row] {
        case is TopSectionOnFeedDetail.Type:
            let cell: TopSectionOnFeedDetail = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(viewModel.thumbnailURLObservable, viewModel.userProfileImageObservable, viewModel.userNicknameDriver, viewModel.userLevelDriver, viewModel.likeCountDriver, viewModel.scrapCountDriver, viewModel.userLevel)
            return cell

        case is TapOnFeedDetail.Type:
            let cell: TapOnFeedDetail = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(viewModel.content, self.selectedTapType, self.selectedTapTypeSubject)
            return cell

        case is RestaurantInformationOnFeedDetail.Type:
            let cell: RestaurantInformationOnFeedDetail = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(category: viewModel.categoryDriver, restaurantName: viewModel.restaurantNameDriver, isWelcome: viewModel.isWelcomeDriver)
            return cell

        case is LevelOfDifficultyOnFeedDetail.Type:
            let cell: LevelOfDifficultyOnFeedDetail = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(levelOfDifficulty: viewModel.levelOfDifficulty)
            return cell

        case is MenuOnFeedDetail.Type:
            let cell: MenuOnFeedDetail = collectionView.dequeueReusableCell(for: indexPath)
            if isMainMenu {
                cell.mainMenuConfigure(menuAndContainers: viewModel.mainMenuAndContainers)
                isMainMenu = false
            } else if !isMainMenu && viewModel.sideMenuAndContainers.count > 0 {
                cell.sideMenuConfigure(menuAndContainers: viewModel.sideMenuAndContainers)
            }
            return cell

        case is ContentOnFeedDetail.Type:
            let cell: ContentOnFeedDetail = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(content: viewModel.content)
            return cell

        default: return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch viewModel.modules[indexPath.row] {
        case is TopSectionOnFeedDetail.Type: return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(329))

        case is TapOnFeedDetail.Type: return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(37))

        case is RestaurantInformationOnFeedDetail.Type: return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(viewModel.isWelcome ? 132 : 100))

        case is LevelOfDifficultyOnFeedDetail.Type:
            return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(86))

        case is MenuOnFeedDetail.Type:
            var cellHeight = CGFloat(112)
            let isTwoOrMoreMainMenu = isMainMenu && viewModel.mainMenuAndContainers.count > 1
            let isTwoOrMoreSideMenu = !isMainMenu && viewModel.sideMenuAndContainers.count > 1
            if isTwoOrMoreMainMenu {
                cellHeight += CGFloat(64 * (viewModel.mainMenuAndContainers.count - 1))
            } else if isTwoOrMoreSideMenu {
                cellHeight += CGFloat(64 * (viewModel.sideMenuAndContainers.count - 1))
            }
            return CGSize(width: UIScreen.main.bounds.width, height: cellHeight)

        case is ContentOnFeedDetail.Type:
            let labelHeight = Common.labelHeight(text: viewModel.content, font: .systemFont(ofSize: 14), width: CGFloat(343).widthRatio())
//            let labelHeight = Common.labelHeight(text: "신전떡볶이 용기낸 후기입니다😙 사장님이 다회용기를 환영하는 뱃지를 보고 바로 가서 담아왔습니다! 생각보다 어렵지 않고 환경을 지키는 것에 대해 동참한다는 게 뿌듯하네요 신전떡볶이 용기낸 후기입니다😙 사장님이 다회용기를 환영하는 뱃지를 보고 바로 가서 담아왔습니다! 생각보다 어렵지 않고 환경을 지키는 것에 대해 동참한다는 게 뿌듯하네요", font: .systemFont(ofSize: 14), width: CGFloat(343).widthRatio())
            let otherHeight = CGFloat(26+1)
            let cellHeight = labelHeight + otherHeight

            return CGSize(width: UIScreen.main.bounds.width, height: cellHeight)

        default: return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}
