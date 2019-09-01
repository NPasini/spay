//
//  BeersResponseMock.swift
//  spay
//
//  Created by Pasini, Nicolò on 01/09/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation

extension BeersResponse {
    static func mockedValue() -> CustomDecodable {
        let fakeMalt1 = Malt(name: "M1", amount: Amount(unit: "kg", value: 10))
        let fakeMalt2 = Malt(name: "M2", amount: Amount(unit: "kg", value: 20))
        let fakeMalt3 = Malt(name: "M3", amount: Amount(unit: "kg", value: 30))
        
        let fakeHop1 = Hop(add: "end", name: "H1", amount: Amount(unit: "grams", value: 20), attribute: "flavour")
        let fakeHop2 = Hop(add: "start", name: "H2", amount: Amount(unit: "grams", value: 30), attribute: "bitter")
        let fakeHop3 = Hop(add: "start", name: "H3", amount: Amount(unit: "grams", value: 10), attribute: "flavour")
        
        let fakeBeer1 = Beer(id: 1, hops: [fakeHop1], name: "Fake Beer 1", yeast: "Y1", malts: [fakeMalt1], tagline: "Fake tagline 1", imageUrl: nil, description: "Fake description 1")
        
        let fakeBeer2 = Beer(id: 2, hops: [fakeHop1, fakeHop2], name: "Fake Beer 2", yeast: "Y2", malts: [fakeMalt1, fakeMalt2], tagline: "Fake tagline 2", imageUrl: nil, description: "Fake description 2")
        
        let fakeBeer3 = Beer(id: 3, hops: [fakeHop3], name: "Fake Beer 3", yeast: "Y3", malts: [fakeMalt2, fakeMalt3], tagline: "Fake tagline 3", imageUrl: nil, description: "Fake description 3")
        
        return BeersResponse(beers: [fakeBeer1, fakeBeer2, fakeBeer3])
    }
}
