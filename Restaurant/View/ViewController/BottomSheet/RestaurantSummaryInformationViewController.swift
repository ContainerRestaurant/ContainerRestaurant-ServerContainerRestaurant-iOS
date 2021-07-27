//
//  RestaurantSummaryInformationViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/27.
//

import UIKit

class RestaurantSummaryInformationViewController: BaseViewController, Storyboard {
    weak var coordinator: RestaurantSummaryInformationCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("RestaurantSummaryInformationViewController viewDidLoad()")
    }
    
    deinit {
        print("RestaurantSummaryInformationViewController Deinit")
    }
}
