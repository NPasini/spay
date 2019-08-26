//
//  ViewProtocols.swift
//  spay
//
//  Created by Pasini, Nicolò on 26/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation

protocol BeerCellDelegate: class {
    func showMoreDetails(for model: Beer)
}

protocol BeerDetailsViewDelegate: class {
    func closeDetailsView()
}
