//
//  HomeViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/04.
//

import UIKit

class HomeViewController: BaseViewController, Storyboard, ViewModelBindableType {
    weak var coordinator: HomeCoordinator?
    var viewModel: HomeViewModel!
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = ""
        self.setCollectionView()

        print("HomeViewController viewDidLoad()")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.coordinator?.presenter.navigationBar.isHidden = true

        APIClient.checkLogin(loginToken: UserDataManager.sharedInstance.loginToken) { [weak self] userModel in
            if userModel.id == 0 {
                UserDataManager.sharedInstance.loginToken = ""
                UserDataManager.sharedInstance.userID = 0
                UserDataManager.sharedInstance.fromWhereLogin = ""
            }

            APIClient.homeMainData { [weak self] in
                self?.viewModel.homeMainData = $0
                self?.collectionView.reloadData()
            }
        }
    }

    func bindingView() {
        print("Home bindingView")
    }

    deinit {
        print("HomeViewController Deinit")
    }
}

//MARK: - Instance Method
extension HomeViewController {
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(MainTitleSection.self)
        self.collectionView.register(MainBanner.self)
        self.collectionView.register(Title16Bold.self)
        self.collectionView.register(SeparateLineCollectionViewCell.self)
        self.collectionView.register(TwoFeedInLineCollectionView.self)
        self.collectionView.register(ViewMoreButton.self)
        self.collectionView.register(FooterSection.self)
    }
}

//MARK: - CollectionView Protocol
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.modules.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = viewModel.modules[indexPath.row]
        
        switch type {
        case is MainTitleSection.Type:
            let cell: MainTitleSection = collectionView.dequeueReusableCell(for: indexPath)
            if let coordinator = self.coordinator {
                cell.configure(coordinator: coordinator, homeMainData: viewModel.homeMainData)
            }
            return cell

        case is MainBanner.Type:
            let cell: MainBanner = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(coordinator, viewModel.homeMainData.banners)
            return cell

        case is SeparateLineCollectionViewCell.Type:
            let cell: SeparateLineCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configureCell(height: 28, color: .clear)
            return cell
            
        case is Title16Bold.Type:
            let cell: Title16Bold = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(title: "용기낸 특별한 경험들")
            return cell
            
        case is TwoFeedInLineCollectionView.Type:
            let cell: TwoFeedInLineCollectionView = collectionView.dequeueReusableCell(for: indexPath)
            if let coordinator = self.coordinator {
                cell.configureHomeMainFeed(viewModel.recommendFeeds, coordinator)
            }
            return cell
            
        case is ViewMoreButton.Type:
            let cell: ViewMoreButton = collectionView.dequeueReusableCell(for: indexPath)
            if let coordinator = self.coordinator {
                cell.configure(coordinator)
            }
            return cell
            
        case is FooterSection.Type:
            let cell: FooterSection = collectionView.dequeueReusableCell(for: indexPath)
            return cell
            
        default: return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //TODO : 이 부분도 is ReusableCell로 해야할지 고민하기
        switch indexPath.row {
        case 0: return viewModel.mainTitleSectionSize()
        case 1: return viewModel.mainBannerSize()
        case 2: return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(28))
        case 3: return viewModel.title16BoldSize()
        case 4: return viewModel.MainFeedCollectionViewSize()
        case 5: return viewModel.viewMoreButtonSize()
        case 6: return viewModel.footerSectionSize()
        default: return CGSize.zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
