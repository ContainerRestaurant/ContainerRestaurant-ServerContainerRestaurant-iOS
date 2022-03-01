//
//  Common.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/06/01.
//

import UIKit

struct Common {
    static var homeBarHeight: CGFloat = 34 // home indicator
    static var tabBarHeight: CGFloat = 48
    static var notchHeight: CGFloat = 48

    //topViewController에서 currentViewController로 수정
    static func currentViewController() -> UIViewController? {
        var viewController = UIApplication.shared.windows.first!.rootViewController

        while viewController?.presentedViewController != nil {
            viewController = viewController?.presentedViewController!
        }
        print("currentViewController -> \(String(describing: viewController))")

        return viewController
    }

    //피드 상세의 content 영역에 쓰임
    //추후 커스터마이징 필요하면 attrString 분기 처리해야함
    static func labelHeight(text: String, font: UIFont, width: CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.font = font
        label.text = text

        let attrString = NSMutableAttributedString(string: label.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        label.attributedText = attrString
        label.sizeToFit()

        return label.frame.height
    }

    static func hapticVibration() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    static func pushFromTopTransition() -> CATransition {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .push
        transition.subtype = .fromTop

        return transition
    }

    static func openAppStore(appId: String) {
        let url = "itms-apps://itunes.apple.com/app/" + appId;
        if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

//레벨별 프로필 이미지
extension Common {
    //레벨별 프로필 이미지 148
    static func getDefaultProfileImage148(_ levelTitle: String) -> UIImage? {
        switch levelTitle {
        case "LV1. 텀블러": return UIImage(named: "ProfileTumbler148px")
        case "LV2. 밥그릇": return UIImage(named: "ProfileBowl148px")
        case "LV3. 용기 세트": return UIImage(named: "ProfileContainerSet148px")
        case "LV4. 후라이팬": return UIImage(named: "ProfileFryingPan148px")
        case "LV5. 냄비": return UIImage(named: "ProfilePot148px")
        default: return nil//UIImage(named: "ProfileTumbler148px")
        }
    }

    //레벨별 프로필 이미지 74
    static func getDefaultProfileImage74(_ levelTitle: String) -> UIImage? {
        switch levelTitle {
        case "LV1. 텀블러": return UIImage(named: "ProfileTumbler74px")
        case "LV2. 밥그릇": return UIImage(named: "ProfileBowl74px")
        case "LV3. 용기 세트": return UIImage(named: "ProfileContainerSet74px")
        case "LV4. 후라이팬": return UIImage(named: "ProfileFryingPan74px")
        case "LV5. 냄비": return UIImage(named: "ProfilePot74px")
        default: return nil//UIImage(named: "ProfileTumbler148px")
        }
    }

    //레벨별 프로필 이미지 42
    static func getDefaultProfileImage42(_ levelTitle: String) -> UIImage? {
        switch levelTitle {
        case "LV1. 텀블러": return UIImage(named: "profileTumbler42px")
        case "LV2. 밥그릇": return UIImage(named: "profileBowl42px")
        case "LV3. 용기 세트": return UIImage(named: "profileContainerSet42px")
        case "LV4. 후라이팬": return UIImage(named: "profileFryingPan42px")
        case "LV5. 냄비": return UIImage(named: "profilePot42px")
        default: return nil//UIImage(named: "ProfileTumbler148px")
        }
    }

    //레벨별 프로필 이미지 36
    static func getDefaultProfileImage36(_ levelTitle: String) -> UIImage? {
        switch levelTitle {
        case "LV1. 텀블러": return UIImage(named: "ProfileTumbler36px")
        case "LV2. 밥그릇": return UIImage(named: "ProfileBowl36px")
        case "LV3. 용기 세트": return UIImage(named: "ProfileContainerSet36px")
        case "LV4. 후라이팬": return UIImage(named: "ProfileFryingPan36px")
        case "LV5. 냄비": return UIImage(named: "ProfilePot36px")
        default: return nil//UIImage(named: "ProfileTumbler148px")
        }
    }

    //레벨별 프로필 이미지 32
    static func getDefaultProfileImage32(_ levelTitle: String) -> UIImage? {
        switch levelTitle {
        case "LV1. 텀블러": return UIImage(named: "profileTumbler32px")
        case "LV2. 밥그릇": return UIImage(named: "profileBowl32px")
        case "LV3. 용기 세트": return UIImage(named: "profileContainerSet32px")
        case "LV4. 후라이팬": return UIImage(named: "profileFryingPan32px")
        case "LV5. 냄비": return UIImage(named: "profilePot32px")
        default: return nil//UIImage(named: "ProfileTumbler148px")
        }
    }

    //레벨별 메인 프로필 이미지
    static func getMainProfileImage(_ levelTitle: String) -> UIImage? {
        switch levelTitle {
        case "LV1. 텀블러": return UIImage(named: "level1Tumbler")
        case "LV2. 밥그릇": return UIImage(named: "level2Bowl")
        case "LV3. 용기 세트": return UIImage(named: "level3ContainerSet")
        case "LV4. 후라이팬": return UIImage(named: "level4FryingPan")
        case "LV5. 냄비": return UIImage(named: "level5Pot")
        default: return nil//UIImage(named: "ProfileTumbler148px")
        }
    }

    static func getLevelUpImage(_ levelTitle: String) -> UIImage? {
        switch levelTitle {
        case "LV1. 텀블러": return UIImage(named: "levelUpTumbler")
        case "LV2. 밥그릇": return UIImage(named: "levelUpBowl")
        case "LV3. 용기 세트": return UIImage(named: "levelUpContainerSet")
        case "LV4. 후라이팬": return UIImage(named: "levelUpFryingPan")
        case "LV5. 냄비": return UIImage(named: "levelUpPot")
        default: return nil//UIImage(named: "ProfileTumbler148px")
        }
    }
}
