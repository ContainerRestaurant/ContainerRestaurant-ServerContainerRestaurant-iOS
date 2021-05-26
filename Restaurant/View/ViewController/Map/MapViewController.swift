//
//  MapViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/06.
//

import UIKit

class MapViewController: BaseViewController, Storyboard {
    weak var coordinator: MapCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController viewDidLoad()")
    }
}
