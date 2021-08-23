//
//  ContainerOfEveryoneViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/09.
//

import UIKit

class ContainerOfEveryoneViewController: BaseViewController, ViewModelBindableType, Storyboard {
    var viewModel: ContainerOfEveryoneViewModel!
    weak var coordinator: ContainerOfEveryoneCoordinator?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()
        print("ContainerOfEveryoneViewController viewDidLoad()")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigation()
    }
    
    func bindingView() {
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        HomeViewController.homeNavigationBarAnimated = true
    }
    
    deinit {
        print("ContainerOfEveryoneViewController Deinit")
    }
}

//MARK: - Instance Method
extension ContainerOfEveryoneViewController {
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(MostFeedCreationUserCollectionView.self)
        self.collectionView.register(RecentlyFeedCreationUserCollectionView.self)
    }
    
    private func setNavigation() {
        //Back Button
        let backImage = UIImage(named: "chevronLeftOutline20Px")
        self.coordinator?.presenter.navigationBar.backIndicatorImage = backImage
        self.coordinator?.presenter.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.coordinator?.presenter.navigationBar.backItem?.title = "" //확인 필요
        
        //Help Button
        let helpButton = UIButton(type: .custom)
        helpButton.setImage(UIImage(named: "helpOutline20Px"), for: .normal)
        helpButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        helpButton.addTarget(self, action: #selector(listStandardDescriptionPopup), for: .touchUpInside)
        let helpRightBarButtonItem = UIBarButtonItem(customView: helpButton)
        self.navigationItem.rightBarButtonItem = helpRightBarButtonItem
        
        self.coordinator?.presenter.navigationBar.isHidden = false
        self.coordinator?.presenter.navigationBar.isTranslucent = false
        self.coordinator?.presenter.navigationBar.barTintColor = .colorMainGreen02
        self.coordinator?.presenter.navigationBar.tintColor = .colorGrayGray01
        self.coordinator?.presenter.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.colorGrayGray01]

        self.navigationItem.title = "모두의 용기"
    }
    
    @objc func listStandardDescriptionPopup() {
        self.coordinator?.presentToListStandardDescription()
    }
}

//MARK: - CollectoinView Protocol
extension ContainerOfEveryoneViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.modules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = viewModel.modules[indexPath.row]

        switch type {
        case is MostFeedCreationUserCollectionView.Type:
            let cell: MostFeedCreationUserCollectionView = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(self.viewModel.mostFeedCreationUsers, self.coordinator!)
            return cell

        case is RecentlyFeedCreationUserCollectionView.Type:
            let cell: RecentlyFeedCreationUserCollectionView = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(self.viewModel.recentlyFeedCreationUsers, self.coordinator!)
            return cell

        default: return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let type = viewModel.modules[indexPath.row]

        switch type {
        case is MostFeedCreationUserCollectionView.Type: return viewModel.mostFeedTopTenSize()
        case is RecentlyFeedCreationUserCollectionView.Type: return viewModel.RecentlyFeedSize()
        default: return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

