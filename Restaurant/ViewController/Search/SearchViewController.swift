//
//  SearchViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/06.
//

import UIKit

class SearchViewController: BaseViewController, Storyboard {
    weak var coordinator: SearchCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SearchViewController viewDidLoad()")
    }
    
    func bind() {
        print("SearchViewController Bind()")
    }
}
