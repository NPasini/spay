//
//  UIView+Nib.swift
//  spay
//
//  Created by Pasini, Nicolò on 24/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import UIKit

protocol Identifiable {
    static var identifier: String {
        get
    }
    
    static func nib() -> UINib
}

extension Identifiable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        let bundle = Bundle(for: self)
        return bundle.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    static func nib() -> UINib {
        let bundle = Bundle(for: self)
        
        var nibName: String
        
        if let identity = self as? Identifiable.Type {
            nibName = identity.identifier
        } else {
            nibName = String(describing: self)
        }
        
        return UINib(nibName: nibName, bundle: bundle)
    }
    
    static func Inflate<T: UIView>(type: T.Type, owner: Any?, inside contentView: UIView, referenceToSafeArea: Bool = false) -> T? {
        
        guard let view = Bundle.main.getView(from: type, owner: owner) else {
            return nil
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        
        if (referenceToSafeArea) {
            NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            view.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor),
            view.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            view.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        }
        
        return view
    }
}

//protocol SizeableCell: class {
//    static var estimatedHeight: CGFloat {
//        get
//    }
//}
//
//protocol SizeableCollectionCell: class {
//    static var estimatedSize: CGSize {
//        get
//    }
//}
