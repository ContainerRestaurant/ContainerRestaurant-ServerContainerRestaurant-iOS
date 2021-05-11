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
        
        self.navigationController?.title = "프로필 조회"
        topSectionView.clipsToBounds = true
        topSectionView.layer.cornerRadius = 24
        topSectionView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
}
