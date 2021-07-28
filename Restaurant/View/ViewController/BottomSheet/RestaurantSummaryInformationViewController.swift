//
//  RestaurantSummaryInformationViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/27.
//

import UIKit
import Cosmos

class RestaurantSummaryInformationViewController: BaseViewController, Storyboard {
    weak var coordinator: RestaurantSummaryInformationCoordinator?
    var restaurant: RestaurantModel?

    @IBOutlet weak var welcomeView: UIView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var levelOfDifficultyView: CosmosView!
    @IBOutlet weak var levelOfDifficultyLabel: UILabel!
    @IBOutlet weak var feedCountButton: UIButton!
    @IBOutlet weak var firstMenuButton: UIButton!
    @IBOutlet weak var secondMenuButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        bindingView()

        print("RestaurantSummaryInformationViewController viewDidLoad()")
    }

    private func bindingView() {
//        self.welcomeView.isHidden = restaurant.
        restaurantNameLabel.text = self.restaurant?.name
        levelOfDifficultyView.rating = self.restaurant?.difficultyAverage ?? 0.0
        levelOfDifficultyLabel.text = "\(self.restaurant?.difficultyAverage ?? 0.0)"
        feedCountButton.setTitle("\(self.restaurant?.feedCount ?? 0)", for: .normal)
//        firstMenuButton.setTitle(<#T##title: String?##String?#>, for: <#T##UIControl.State#>)
//        secondMenuButton.setTitle(<#T##title: String?##String?#>, for: <#T##UIControl.State#>)
    }
    
    deinit {
        print("RestaurantSummaryInformationViewController Deinit")
    }
}
