//
//  BeersResponse.swift
//  spayUITests
//
//  Created by Pasini, Nicolò on 26/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

@testable import spay

import Foundation

extension BeersResponse {
    static func valueForTest() -> CustomDecodable {
        let path = Bundle(for: LaunchTest.self).path(forResource: "getBeersMock", ofType: "json") ?? ""
        let data = (try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe))
        
        guard let dataObject = data else {
            return BeersResponse(beers: [])
        }
        
        return BeersResponse(beers: [])
    }
}
