//
//  Bundle+View.swift
//  spay
//
//  Created by Pasini, Nicolò on 26/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import UIKit

extension Bundle {
    func getView<T: UIView>(from class: T.Type, owner: Any? ) -> T? {
        return self.loadNibNamed(String(describing: T.self), owner: owner, options: nil)?.first as? T
    }
}
