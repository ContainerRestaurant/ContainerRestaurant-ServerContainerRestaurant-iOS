//
//  ExtensionCollectoinView.swift
//  Restaurant
//
//  Created by 0ofKim on 2021/04/26.
//

import Foundation
import UIKit

extension UICollectionView {
//    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableCollectionViewCell {
//        register(T.self, forCellWithReuseIdentifier: T.identifier)
//    }
    
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableCollectionViewCell {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        
        register(nib, forCellWithReuseIdentifier: T.identifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: ReusableCollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.identifier)")
        }
        
        return cell
    }
}

typealias ReusableCell = ReusableCollectionViewCell

protocol ReusableCollectionViewCell: AnyObject {
    static var identifier: String { get }
    static var nibName: String { get }
}

extension ReusableCollectionViewCell where Self: UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nibName: String {
        return String(describing: self)
    }
}
