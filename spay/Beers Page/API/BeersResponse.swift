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
            OSLogger.networkLog(message: "Beers Response contains \(beersArray.count) objects", access: .public, type: .debug)
            return BeersResponse(beers: beersArray)
        } else {
            OSLogger.networkLog(message: "Decoding of Beers Response was not successful", access: .public, type: .debug)
            return nil
        }
    }
    
    static func valueForTest() -> CustomDecodable {
        let beer1 = Beer(id: 1, name: "Fake Beer 1", malts: [Malt(name: "M1")], tagline: "Fake tagline 1", imageUrl: nil, description: "Fake description 1")
        
        let beer2 = Beer(id: 2, name: "Fake Beer 2", malts: [Malt(name: "M1"), Malt(name: "M2")], tagline: "Fake tagline 2", imageUrl: nil, description: "Fake description 2")
        
        let beer3 = Beer(id: 3, name: "Fake Beer 3", malts: [Malt(name: "M2"), Malt(name: "M3")], tagline: "Fake tagline 3", imageUrl: nil, description: "Fake description 3")
        
        return BeersResponse(beers: [beer1, beer2, beer3])
    }
}
