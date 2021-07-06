//
//  FeedViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/06.
//

import UIKit

class FeedViewController: BaseViewController, Storyboard, ViewModelBindableType {
    var viewModel: FeedViewModel!
    
    weak var coordinator: FeedCoordinator?
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var latestOrderButton: UIButton!
    @IBOutlet weak var orderOfManyLikeButton: UIButton!
    @IBOutlet weak var orderOfLowDifficultyButton: UIButton!
    @IBOutlet weak var feedCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
    }
    
    func bindingView() {
        print("Search bindingView")
    }
}

//MARK: - Instance Method
extension FeedViewController {
    private func setNavigationBar() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationItem.title = "피드탐색"
        
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
        UINavigationBar.appearance().titleTextAttributes = attributes
    }
}

//MARK: - CollectionView Protocol
extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}
