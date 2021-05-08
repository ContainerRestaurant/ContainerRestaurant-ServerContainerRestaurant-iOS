//
//  HomeViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/04.
//

import UIKit

class HomeViewController: BaseViewController, ViewModelBindableType {
    var viewModel: HomeViewModel!
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = HomeViewModel()
        setNavigationController()
        setCollectionView()
    }
    
    func bindViewModel() {
        
    }
    
    //안될거임
    deinit {
        print("HomeViewController Deinit")
    }
}

//MARK: - Instance Method
extension HomeViewController {
    private func setNavigationController() {
        self.navigationController?.navigationBar.isHidden = true
    }

    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(MainTitleSection.self)
        self.collectionView.register(Title16Bold.self)
        self.collectionView.register(MainFeedCollectionView.self)
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
        case is MainTitleSection:
            let cell: MainTitleSection = collectionView.dequeueReusableCell(for: indexPath)
            return cell
            
        case is Title16Bold:
            let cell: Title16Bold = collectionView.dequeueReusableCell(for: indexPath)
            return cell
            
        case is MainFeedCollectionView:
            let cell: MainFeedCollectionView = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(dummyNumber: 9)
            return cell
            
        default: return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //TODO : 이 부분도 is ReusableCell로 해야할지 고민하기
        switch indexPath.row {
        case 0: return viewModel.mainTitleSectionSize()
        case 1: return viewModel.title16Bold()
        case 2: return viewModel.MainFeedCollectionViewSize()
        default: return CGSize.zero
        }
    }
}
