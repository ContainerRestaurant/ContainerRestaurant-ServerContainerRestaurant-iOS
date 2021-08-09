//
//  SettingCollectionViewCell.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/08/09.
//

import UIKit

class SettingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var settingTitleLabel: UILabel!
    @IBOutlet weak var alertSettingSwitch: UISwitch!
    @IBOutlet weak var chevronRightButton: UIButton!
    @IBOutlet weak var appVersionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(title: String) {
        settingTitleLabel.text = title
        alertSettingSwitch.isHidden = true
        chevronRightButton.isHidden = false
        appVersionLabel.isHidden = true
    }

    func alertConfigure() {
        settingTitleLabel.text = "알림 수신 설정"
        alertSettingSwitch.isHidden = false
        chevronRightButton.isHidden = true
        appVersionLabel.isHidden = true
    }

    func appVersionConfigure() {
        settingTitleLabel.text = "앱 버전"
        alertSettingSwitch.isHidden = true
        chevronRightButton.isHidden = true
        appVersionLabel.isHidden = false
    }
}
