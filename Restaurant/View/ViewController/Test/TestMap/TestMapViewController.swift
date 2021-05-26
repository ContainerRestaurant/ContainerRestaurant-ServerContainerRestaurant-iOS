//
//  TestMapViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/13.
//

import UIKit
import NMapsMap

class TestMapViewController: BaseViewController, Storyboard {
    weak var coordinator: TestMapCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = NMFMapView(frame: view.frame)
        view.addSubview(mapView)
    }

    deinit {
        print("TestMapViewController deinit")
    }
}
