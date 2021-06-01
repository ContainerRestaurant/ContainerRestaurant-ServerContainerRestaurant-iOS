//
//  InquiryProfileViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/12.
//

import UIKit

class InquiryProfileViewController: BaseViewController, Storyboard, UINavigationBarDelegate {
    weak var coordinator: InquiryProfileCoordinator?
    
    @IBOutlet weak var topSectionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setNavigation()
        setTopSectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigation()
    }
    
    private func setNavigation() {
        self.coordinator?.presenter.navigationBar.barTintColor = .white
        self.coordinator?.presenter.navigationBar.tintColor = .colorGrayGray08
        self.coordinator?.presenter.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.colorGrayGray08]
        self.coordinator?.presenter.navigationBar.isTranslucent = false
        self.coordinator?.presenter.navigationBar.topItem?.title = ""
        self.navigationItem.title = "프로필 조회"
    }
    
    private func setTopSectionView() {
        self.topSectionView.clipsToBounds = true
        self.topSectionView.layer.cornerRadius = 24
        self.topSectionView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    deinit {
        print("InquiryProfileViewController Deinit")
    }
}
