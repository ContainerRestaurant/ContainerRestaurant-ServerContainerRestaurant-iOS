//
//  ContentOnFeedDetail.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/08/16.
//

import UIKit

class ContentOnFeedDetail: UICollectionViewCell {
    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(content: String) {
        contentLabel.text = content
//        contentLabel.text = "신전떡볶이 용기낸 후기입니다😙 사장님이 다회용기를 환영하는 뱃지를 보고 바로 가서 담아왔습니다! 생각보다 어렵지 않고 환경을 지키는 것에 대해 동참한다는 게 뿌듯하네요 신전떡볶이 용기낸 후기입니다😙 사장님이 다회용기를 환영하는 뱃지를 보고 바로 가서 담아왔습니다! 생각보다 어렵지 않고 환경을 지키는 것에 대해 동참한다는 게 뿌듯하네요"
    }
}
