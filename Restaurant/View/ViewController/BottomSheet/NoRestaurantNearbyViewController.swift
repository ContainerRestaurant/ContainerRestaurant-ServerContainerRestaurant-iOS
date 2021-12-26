//
//  NoRestaurantNearbyViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/23.
//

import UIKit

class NoRestaurantNearbyViewController: BaseViewController, Storyboard {
    weak var coordinator: NoRestaurantNearbyCoordinator?
    weak var searchingRestaurantCoordinator: SearchingRestaurantPopupCoordinator?
    var isHiddenFindNearestRestaurantButton = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var beBraveInFirstButton: UIButton!
    @IBAction func beBraveInFirst(_ sender: Any) {
        if let coordinator = self.coordinator {
            self.dismiss(animated: true, completion: nil)
            coordinator.presenter.tabBarController?.selectedIndex = 2
            coordinator.presentCreationFeed()
        } else {
            self.dismiss(animated: true, completion: nil)
            searchingRestaurantCoordinator?.presenter.tabBarController?.selectedIndex = 2
            searchingRestaurantCoordinator?.presentCreationFeed()
        }
    }
    @IBOutlet weak var findNearestRestaurantButton: UIButton!
    @IBAction func findNearestRestaurant(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.coordinator?.presentSearchingRestaurantPopup()
    }
    @IBAction func dismissViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if isHiddenFindNearestRestaurantButton {
            self.findNearestRestaurantButton.isHidden = true
            self.titleLabel.text = "가까운 곳에\n용기낸 식당이 없어요"
        }
        
        print("NoRestaurantNearbyViewController viewDidLoad()")
    }
    
    deinit {
        print("NoRestaurantNearbyViewController Deinit")
    }
}
