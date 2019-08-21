//
//  BeersRequest.swift
//  spay
//
//  Created by Pasini, Nicolò on 20/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation

class BeersRequest: GetRequest<BeersResponse> {
    init(page: Int = 1) {
        let host = "api.punkapi.com"
        let version = "/v2"
        let path = "/beers"
        
        let queryParameters = ["page": page]
        
        super.init(host: host, path: path, version: version, queryParameters: queryParameters)
    }
    
    override func validateResponseObject(_ object: BeersResponse) -> NSError? {
        guard object.beers.count > 0 else {
            return SPError(networkError: .emptyResponse)
        }
        
        return nil
    }
    
    override func validateResponse(_ response: URLResponse) -> NSError? {
        guard let httpResponse = response as? HTTPURLResponse else {
            return SPError(statusError: .notFound, statusCode: 404)
        }
        
        switch httpResponse.statusCode {
        case 200...399:
            return nil
        case 404:
            return SPError(statusError: .notFound, statusCode: httpResponse.statusCode)
        default:
            return SPError(statusError: .badAnswer, statusCode: httpResponse.statusCode)
        }
    }
}
