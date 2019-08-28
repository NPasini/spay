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
        let m1 = Malt(name: "M1", amount: Amount(unit: "kg", value: 10))
        let m2 = Malt(name: "M2", amount: Amount(unit: "kg", value: 20))
        let m3 = Malt(name: "M3", amount: Amount(unit: "kg", value: 30))
        
        let h1 = Hop(add: "start", name: "H1", amount: Amount(unit: "grams", value: 10), attribute: "flavour")
        let h2 = Hop(add: "end", name: "H2", amount: Amount(unit: "grams", value: 20), attribute: "flavour")
        let h3 = Hop(add: "start", name: "H3", amount: Amount(unit: "grams", value: 30), attribute: "bitter")
        
        let beer1 = Beer(id: 1, hops: [h1], name: "Fake Beer 1", yeast: "Y1", malts: [m1], tagline: "Fake tagline 1", imageUrl: nil, description: "Fake description 1")
        
        let beer2 = Beer(id: 2, hops: [h1, h3], name: "Fake Beer 2", yeast: "Y2", malts: [m1, m2], tagline: "Fake tagline 2", imageUrl: nil, description: "Fake description 2")
        
        let beer3 = Beer(id: 3, hops: [h2], name: "Fake Beer 3", yeast: "Y3", malts: [m2, m3], tagline: "Fake tagline 3", imageUrl: nil, description: "Fake description 3")
        
        return BeersResponse(beers: [beer1, beer2, beer3])
    }
}
