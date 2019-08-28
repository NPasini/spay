//
//  Hop.swift
//  spay
//
//  Created by Pasini, Nicolò on 28/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation

struct Hop: Decodable {
    let add: String
    let name: String
    let amount: Amount
    let attribute: String
}
