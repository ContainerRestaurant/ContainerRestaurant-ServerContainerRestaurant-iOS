//
//  NearbyRestaurantsViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/26.
//

import UIKit

class NearbyRestaurantsViewController: BaseViewController, Storyboard, ViewModelBindableType {
    var viewModel: NearbyRestaurantsViewModel!
    weak var coordinator: NearbyRestaurantsCoordinator?

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setCollectionView()
        print("NearbyRestaurantsViewController viewDidLoad()")
    }
    
    deinit {
        print("NearbyRestaurantsViewController Deinit")
    }
    
    func bindingView() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNavigation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        MapViewController.mapNavigationBarAnimated = true
    }
}

extension NearbyRestaurantsViewController {
    private func setNavigation() {
        let backImage = UIImage(named: "chevronLeftOutline20Px")
        self.coordinator?.presenter.navigationBar.backIndicatorImage = backImage
        self.coordinator?.presenter.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.coordinator?.presenter.navigationBar.backItem?.title = ""
        self.coordinator?.presenter.navigationBar.isTranslucent = false
        self.coordinator?.presenter.navigationBar.tintColor = .colorGrayGray07
        self.coordinator?.presenter.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.colorGrayGray07]
        
        self.navigationItem.title = "반경 2km 용기낸 식당"
    }
    
    private func setCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(OneFeedCollectionViewCell.self)
    }
}

extension NearbyRestaurantsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.nearbyRestaurants.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: OneFeedCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(viewModel.nearbyRestaurants[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(375).widthRatio(), height: 96)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
}
