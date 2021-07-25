//
//  NoRestaurantNearbyViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/23.
//

import UIKit

class NoRestaurantNearbyViewController: BaseViewController, Storyboard {
    weak var coordinator: NoRestaurantNearbyCoordinator?
    
    @IBOutlet weak var beBraveInFirstButton: UIButton!
    @IBAction func beBraveInFirst(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.coordinator?.presenter.tabBarController?.selectedIndex = 2
        self.coordinator?.presentCreationFeed()
    }
    @IBOutlet weak var findNearestRestaurantButton: UIButton!
    @IBAction func findNearestRestaurant(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.coordinator?.presentSearchingRestaurantPopup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("NoRestaurantNearbyViewController viewDidLoad()")
    }
    
    deinit {
        print("NoRestaurantNearbyViewController Deinit")
    }
}
