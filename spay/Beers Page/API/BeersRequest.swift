//
//  BeersRequest.swift
//  spay
//
//  Created by Pasini, Nicolò on 20/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import OSLogger
import Foundation
import NetworkManager

class BeersRequest: GetRequest<BeersResponse> {
    init(page: Int, searchString: String?, maltFilter: String?) {
        let host = "api.punkapi.com"
        let version = "v2"
        let path = "beers"
        
        var queryParameters: [String : CustomStringConvertible] = ["page": page]
        if let string = searchString, string.count > 0 {
            queryParameters["beer_name"] = string.replacingOccurrences(of: " ", with: "_")
        }
        if let filter = maltFilter, filter.count > 0 {
            queryParameters["malt"] = filter.replacingOccurrences(of: " ", with: "_")
        }
        
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
