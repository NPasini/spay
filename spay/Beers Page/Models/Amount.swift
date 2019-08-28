//
//  Amount.swift
//  spay
//
//  Created by Pasini, Nicolò on 28/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation

struct Amount: Decodable {
    let unit: String
    let value: Double
}
