//
//  UICollectionView+Registrable.swift
//  spay
//
//  Created by Pasini, Nicolò on 26/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import UIKit

extension UICollectionView: Registrable {
    func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        register(nib, forCellWithReuseIdentifier: identifier)
    }
}
