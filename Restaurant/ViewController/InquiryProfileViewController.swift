//
//  InquiryProfileViewController.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/12.
//

import UIKit

class InquiryProfileViewController: UIViewController {
    @IBOutlet weak var topSectionView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "프로필 조회"
        self.topSectionView.clipsToBounds = true
        self.topSectionView.layer.cornerRadius = 24
        self.topSectionView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
}
