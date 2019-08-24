//
//  NetworkError.swift
//  spay
//
//  Created by Pasini, Nicolò on 18/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation

enum NetworkError: Int, Error {
    case missingData
    case parserError
    case unknownError
    case emptyResponse
    case invalidRequest
    case invalidResponse
    case invalidResponseObject
    
    var description: String {
        switch self {
        case .unknownError: return "Unknown error."
        case .parserError: return "Parser error data."
        case .emptyResponse: return "No objects found."
        case .missingData: return "Empty data retrieved."
        case .invalidResponse: return "Invalid response."
        case .invalidRequest: return "Failed to generate request."
        case .invalidResponseObject: return "Data parsed are invalid."
        }
    }
}
