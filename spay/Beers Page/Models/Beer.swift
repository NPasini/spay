//
//  Beer.swift
//  spay
//
//  Created by Pasini, Nicolò on 20/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation

struct Beer: Decodable {
    let id: Int
    let name: String
    let tagline: String
    let image_url: String
    let description: String
}
