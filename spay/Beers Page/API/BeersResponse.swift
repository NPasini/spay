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
        
        if let beersArray = beers {
            OSLogger.log(category: .network, message: "Beers Response contains \(beersArray.count) objects", access: .public, type: .debug)
            return BeersResponse(beers: beersArray)
        } else {
            OSLogger.log(category: .network, message: "Decoding of Beers Response was not successful", access: .public, type: .debug)
            return nil
        }
    }
}
