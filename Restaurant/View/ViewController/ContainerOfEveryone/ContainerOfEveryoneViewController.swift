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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.colorGrayGray07]
        let backImage = UIImage(named: "chevronLeftOutline20Px")
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        self.coordinator?.presenter.navigationBar.standardAppearance = appearance
        self.coordinator?.presenter.navigationBar.compactAppearance = appearance
        self.coordinator?.presenter.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func bindingView() {
        
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
        //Help Button
        let helpButton = UIButton(type: .custom)
        helpButton.setImage(UIImage(named: "helpOutline20Px"), for: .normal)
        helpButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        helpButton.addTarget(self, action: #selector(listStandardDescriptionPopup), for: .touchUpInside)
        let helpRightBarButtonItem = UIBarButtonItem(customView: helpButton)
        self.navigationItem.rightBarButtonItem = helpRightBarButtonItem

        self.coordinator?.presenter.navigationBar.isHidden = false
        self.coordinator?.presenter.navigationBar.isTranslucent = false
        self.coordinator?.presenter.navigationBar.tintColor = .colorGrayGray01

        self.navigationItem.title = "모두의 용기"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .colorMainGreen02
        appearance.titleTextAttributes = [.foregroundColor: UIColor.colorGrayGray01]
        let backImage = UIImage(named: "chevronLeftOutlineWhite20Px")
        appearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        self.coordinator?.presenter.navigationBar.standardAppearance = appearance
        self.coordinator?.presenter.navigationBar.scrollEdgeAppearance = self.coordinator?.presenter.navigationBar.standardAppearance
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
            cell.configure(self.viewModel.mostFeedWriters, self.coordinator!)
            return cell

        case is RecentlyFeedCreationUserCollectionView.Type:
            let cell: RecentlyFeedCreationUserCollectionView = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(self.viewModel.recentlyFeedWriters, self.viewModel.userCount, self.viewModel.feedCount, self.coordinator!)
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

