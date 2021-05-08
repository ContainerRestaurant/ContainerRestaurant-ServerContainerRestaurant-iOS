//
//  ContainerOfEveryoneViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/09.
//

import UIKit

class ContainerOfEveryoneViewController: BaseViewController, ViewModelBindableType {
    var viewModel: ContainerOfEveryoneViewModel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ContainerOfEveryoneViewModel() //바꿔야함
        setCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigation()
    }
    
    func bindViewModel() {
        
    }
    
    deinit {
        print("ContainerOfEveryoneViewController")
    }
}

//MARK: - Instance Method
extension ContainerOfEveryoneViewController {
    private func setNavigation() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "모두의 용기"
    }
    
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(MostFeedTopTenCollectionView.self)
        self.collectionView.register(SeparateLineCollectionViewCell.self)
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
            return cell
            
        case is SeparateLineCollectionViewCell:
            let cell: SeparateLineCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.configureCell(height: 8, color: .colorGreyGrey02)
            return cell
            
        case is RecentlyFeedCollectionView:
            let cell: RecentlyFeedCollectionView = collectionView.dequeueReusableCell(for: indexPath)
            return cell
            
        default: return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0: return viewModel.mostFeedTopTenSize()
        case 1: return viewModel.separateLineSize()
        case 2: return viewModel.RecentlyFeedSize()
        default: return CGSize.zero
        }
    }
}

