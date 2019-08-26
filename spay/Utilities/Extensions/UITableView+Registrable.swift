//
//  UITableView+Registrable.swift
//  spay
//
//  Created by Pasini, Nicolò on 26/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import UIKit

protocol Registrable {
    func register(viewType: Identifiable.Type)
    func register(_ nib: UINib?, forCellReuseIdentifier identifier: String)
}

extension Registrable {
    func register(viewType: Identifiable.Type) {
        register(viewType.nib(), forCellReuseIdentifier: viewType.identifier)
    }
}

extension UITableView: Registrable { }
