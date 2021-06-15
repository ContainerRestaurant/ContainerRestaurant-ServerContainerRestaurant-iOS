//
//  HomeViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/04.
//

import UIKit

class HomeViewController: BaseViewController, Storyboard, ViewModelBindableType {
    static var homeAnimated = false
    var viewModel: HomeViewModel!
    weak var coordinator: HomeCoordinator?
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("HomeViewController viewDidLoad()")
        
        setCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: HomeViewController.homeAnimated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        HomeViewController.homeAnimated = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func bindViewModel() {
        print("Home bindViewModel")
        self.viewModel.recommendFeeds
            .map { $0.first?.ownerNickname }
            .drive(testLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    //안될거임
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
            if let coordinator = self.coordinator { cell.configure(coordinator: coordinator) }
            return cell
            
        case is Title16Bold:
            let cell: Title16Bold = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(title: "용기낸 특별한 경험들")
            return cell
            
        case is MainFeedCollectionView:
            let cell: MainFeedCollectionView = collectionView.dequeueReusableCell(for: indexPath)
            cell.configure(dummyNumber: 12)
            return cell
            
        default: return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //TODO : 이 부분도 is ReusableCell로 해야할지 고민하기
        switch indexPath.row {
        case 0: return viewModel.mainTitleSectionSize()
        case 1: return viewModel.title16BoldSize()
        case 2: return viewModel.MainFeedCollectionViewSize()
        default: return CGSize.zero
        }
    }
}
