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
    @IBOutlet weak var appVersionLabelRightSpacing: NSLayoutConstraint!

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
        APIClient.appVersion() { [weak self] appVersionModel in
            guard let self = self else { return }

            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                let attributedString = NSMutableAttributedString()
                    .regular(string: "앱 버전", fontColor: .colorGrayGray07, fontSize: 14)
                    .regular(string: "  v."+version, fontColor: .colorGrayGray05, fontSize: 14)
                self.settingTitleLabel.attributedText = attributedString

                if version < appVersionModel.latestVersion {
                    self.appVersionLabel.text = "최신 버전으로 업데이트가 필요해요."
                    self.chevronRightButton.isHidden = false
                    self.appVersionLabelRightSpacing.constant = 4
                } else if version >= appVersionModel.latestVersion {
                    self.appVersionLabel.text = "최신 버전을 이용중이에요."
                    self.chevronRightButton.isHidden = true
                    self.appVersionLabelRightSpacing.constant = -16
                }
            }

            self.alertSettingSwitch.isHidden = true
            self.appVersionLabel.isHidden = false
        }
    }
}
