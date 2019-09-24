//
//  BeersResponse.swift
//  spay
//
//  Created by Pasini, Nicolò on 20/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import OSLogger
import Foundation
import NetworkManager

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
            OSLogger.networkLog(message: "Beers Response contains \(beersArray.count) objects", access: .public, type: .debug)
            return BeersResponse(beers: beersArray)
        } else {
            OSLogger.networkLog(message: "Decoding of Beers Response was not successful", access: .public, type: .debug)
            return nil
        }
    }
}
