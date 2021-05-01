//
//  MyContentsCollectionViewCell.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/02.
//

import UIKit

class MyContentsCollectionViewCell: UICollectionViewCell, ReusableCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //임시 파라미터
    func configureCell(imageName: String, title: String) {
        self.imageView.image = UIImage(named: imageName)
        self.title.text = title
    }
}
