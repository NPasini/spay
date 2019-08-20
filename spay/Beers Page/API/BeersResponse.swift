//
//  BeersResponse.swift
//  spay
//
//  Created by Pasini, Nicolò on 20/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation

struct BeersResponse {
    let beers: [Beer]
    
    init(beers: [Beer]) {
        self.beers = beers
    }
}

extension BeersResponse: CustomDecodable {
    static func decode(_ data: Data) -> CustomDecodable? {
        let beers = try? JSONDecoder().decode([Beer].self, from: data)
        return BeersResponse(beers: beers ?? [])
    }
}
