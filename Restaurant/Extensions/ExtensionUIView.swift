//
//  ExtensionUIView.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/05/08.
//

import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }

    @IBInspectable
    var topLeft: Bool {
        get { return layer.maskedCorners.contains(.layerMinXMinYCorner) }
        set {
            if newValue {
                layer.maskedCorners.insert(.layerMinXMinYCorner)
            } else {
                layer.maskedCorners.remove(.layerMinXMinYCorner)
            }
        }
    }

    @IBInspectable
    var topRight: Bool {
        get { return layer.maskedCorners.contains(.layerMaxXMinYCorner) }
        set {
            if newValue {
                layer.maskedCorners.insert(.layerMaxXMinYCorner)
            } else {
                layer.maskedCorners.remove(.layerMaxXMinYCorner)
            }
        }
    }

    @IBInspectable
    var bottomLeft: Bool {
        get { return layer.maskedCorners.contains(.layerMinXMaxYCorner) }
        set {
            if newValue {
                layer.maskedCorners.insert(.layerMinXMaxYCorner)
            } else {
                layer.maskedCorners.remove(.layerMinXMaxYCorner)
            }
        }
    }

    @IBInspectable
    var bottomRight: Bool {
        get { return layer.maskedCorners.contains(.layerMaxXMaxYCorner) }
        set {
            if newValue {
                layer.maskedCorners.insert(.layerMaxXMaxYCorner)
            } else {
                layer.maskedCorners.remove(.layerMaxXMaxYCorner)
            }
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor { return UIColor(cgColor: color) }
            return nil
        }
        set {
            if let color = newValue { layer.borderColor = color.cgColor }
            else { layer.borderColor = nil }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get { return layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor { return UIColor(cgColor: color) }
            return nil
        }
        set {
            if let color = newValue { layer.shadowColor = color.cgColor }
            else { layer.shadowColor = nil }
        }
    }
}

extension UIView {
    func applySketchShadow(color: UIColor = .black, alpha: Float = 0.2, x: CGFloat = 0, y: CGFloat = 2, blur: CGFloat = 4, spread: CGFloat = 0) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = alpha
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = blur / 2
        
        if spread == 0 {
            layer.shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            clipsToBounds = true
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }

    func setHorizontalGradient(startColor: UIColor, endColor: UIColor) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = bounds
        
//        layer.addSublayer(gradient)
        layer.sublayers = [gradient]
    }

    func setVerticalGradient(startColor: UIColor, endColor: UIColor) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = bounds

//        layer.addSublayer(gradient)
        layer.sublayers = [gradient]
    }
}
