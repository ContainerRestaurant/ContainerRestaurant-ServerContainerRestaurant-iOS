//
//  ToastMessage.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/07/29.
//
import Foundation
import UIKit

class ToastMessage {
    public static let shared = ToastMessage()
    private init() {}
    func show(str: String) {
        if let window = UIApplication.shared.windows.first {
            let labelWidth = CGFloat(260).widthRatio()
            let x = window.bounds.width/2 - labelWidth/2
            let y = window.bounds.height/2
            let label = UILabel(frame: CGRect(x: x, y: y, width: labelWidth, height: 40))
            label.text = str
            label.font = .systemFont(ofSize: 12)
            label.textColor = .colorGrayGray01
            label.textAlignment = .center
            label.backgroundColor = .colorGrayGray08
            label.layer.cornerRadius = 5
            label.clipsToBounds = true
            window.addSubview(label)
            label.alpha = 0
            UIView.animate(withDuration: 0, animations: {
                label.alpha = 0.5
            }, completion: { _ in
                UIView.animate(withDuration: 2, animations: {
                    label.alpha = 0
                }, completion: { _ in
                    label.removeFromSuperview()
                })
            })
        }
    }
}
