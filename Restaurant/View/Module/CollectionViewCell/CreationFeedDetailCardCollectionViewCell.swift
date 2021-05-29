//
//  CreationFeedDetailCardCollectionViewCell.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/29.
//

import UIKit

class CreationFeedDetailCardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var mainTextField: UITextField!
    @IBOutlet weak var subTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.mainView.applySketchShadow(color: .colorGrayGray08, alpha: 0.1, x: 0, y: 0, blur: 8, spread: 0)
    }
}
