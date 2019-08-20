//
//  BeersRequest.swift
//  spay
//
//  Created by Pasini, Nicolò on 20/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation

class BeersRequest: GetRequest<BeersResponse> {
    init() {
        let host = "api.punkapi.com"
        let version = "/v2"
        let path = "/beers"
        
        super.init(host: host, path: path, version: version)
    }
}
