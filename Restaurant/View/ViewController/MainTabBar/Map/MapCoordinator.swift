//
//  MapCoordinator.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/16.
//

import UIKit

class MapCoordinator: NSObject, Coordinator {
    var delegate: CoordinatorFinishDelegate?
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
        self.childCoordinators = []
        
        print("MapCoordinator init")
    }
    
    deinit {
        print("MapCoordinator Deinit")
    }
    
    func start() {
        let map = MapViewController.instantiate()
        map.coordinator = self
//        map.bind(viewModel: MapViewModel([])) //이거 쓸거면 setMapView()를 viewWillAppear로 이동
        
        presenter.pushViewController(map, animated: false)
    }
}

