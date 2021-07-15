//
//  FeedDetailViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/14.
//

import UIKit

class FeedDetailViewController: BaseViewController, Storyboard, ViewModelBindableType {
    var viewModel: FeedDetailViewModel!
    weak var coordinator: FeedDetailCoordinator?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
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
        
        self.collectionView.register(FeedDetailTopSection.self)
    }
    
    private func setNavigation() {
        //Back Button
        let backImage = UIImage(named: "chevronLeftOutline20Px")
        self.coordinator?.presenter.navigationBar.backIndicatorImage = backImage
        self.coordinator?.presenter.navigationBar.backIndicatorTransitionMaskImage = backImage
//        self.coordinator?.presenter.navigationBar.backItem?.title = "" //확인 필요
        
        self.coordinator?.presenter.navigationBar.barTintColor = .white
        self.coordinator?.presenter.navigationBar.tintColor = .colorGrayGray08
        self.coordinator?.presenter.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.colorGrayGray08]
        self.coordinator?.presenter.navigationBar.isTranslucent = false
        self.coordinator?.presenter.navigationBar.topItem?.title = ""
//        self.navigationItem.title = "프로필 조회"
    }
}

extension FeedDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: FeedDetailTopSection = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(userNickname: viewModel.userNickname, thumbnailURL: viewModel.thumbnailURL, likeCount: viewModel.likeCount, scrapCount: viewModel.scrapCount)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0: return CGSize(width: UIScreen.main.bounds.width, height: CGFloat(367))
        default: return .zero
        }
    }
}
