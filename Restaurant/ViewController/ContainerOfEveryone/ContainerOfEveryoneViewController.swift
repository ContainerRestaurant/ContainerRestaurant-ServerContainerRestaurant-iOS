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
        
        viewModel = ContainerOfEveryoneViewModel() //바꿔야함
        setCollectionView()
        setNavigation()
    }
    
    func bindViewModel() {
        
    }
    
    deinit {
        print("ContainerOfEveryoneViewController Deinit")
    }
}

//MARK: - Instance Method
extension ContainerOfEveryoneViewController {
    private func setNavigation() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .colorMainGreen02
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.colorGrayGray01]
        self.navigationItem.title = "모두의 용기"
        
        let backImage = UIImage(named: "chevronLeftOutline20Px")
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .colorGrayGray01
        
        let helpButton = UIButton()
        helpButton.setImage(UIImage(named: "helpOutline20Px"), for: .normal)
        helpButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        helpButton.addTarget(self, action: #selector(listStandardDescriptionPopup), for: .touchUpInside)

        let helpBarButtonItem = UIBarButtonItem()
        helpBarButtonItem.customView = helpButton
        
        self.navigationController?.navigationItem.rightBarButtonItem = helpBarButtonItem
        self.navigationItem.rightBarButtonItem = helpBarButtonItem
    }
    
    @objc func listStandardDescriptionPopup() {
        self.coordinator?.presentToListStandardDescription()
    }
    
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(MostFeedTopTenCollectionView.self)
        self.collectionView.register(RecentlyFeedCollectionView.self)
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
        case is MostFeedTopTenCollectionView:
            let cell: MostFeedTopTenCollectionView = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(viewController: self)
            return cell

        case is RecentlyFeedCollectionView:
            let cell: RecentlyFeedCollectionView = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(viewController: self)
            return cell

        default: return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0: return viewModel.mostFeedTopTenSize()
        case 1: return viewModel.RecentlyFeedSize()
        default: return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

