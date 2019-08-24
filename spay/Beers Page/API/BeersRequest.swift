//
//  BeersRequest.swift
//  spay
//
//  Created by Pasini, Nicolò on 20/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation

class BeersRequest: GetRequest<BeersResponse> {
    init(page: Int) {
        let host = "api.punkapi.com"
        let version = "/v2"
        let path = "/beers"
        
        let queryParameters = ["page": page]
        
        super.init(host: host, path: path, version: version, queryParameters: queryParameters)
    }
    
    override func validateResponse(_ response: URLResponse) -> NSError? {
        guard let httpResponse = response as? HTTPURLResponse else {
            OSLogger.networkLog(message: "Received invalid response", access: .public, type: .debug)
            return SPError(networkError: .invalidResponse)
        }
        
        switch httpResponse.statusCode {
        case 200...399:
            return nil
        default:
            OSLogger.networkLog(message: "Received HTTP Response with Error code \(httpResponse.statusCode)", access: .public, type: .debug)
            return SPError(networkError: .invalidResponse)
        }
    }
}
