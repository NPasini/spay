//
//  NetworkError.swift
//  spay
//
//  Created by Pasini, Nicolò on 18/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation

enum NetworkError: Int, Error {
    case statusCode
    case missingData
    case endOfStream
    case parserError
    case unknownError
    case emptyResponse
    case invalidRequest
    case missingRequest
    case invalidResponse
    case invalidResponseObject
    case invalidInputParameters
    
    var description: String {
        switch self {
        case .endOfStream: return "End of stream."
        case .unknownError: return "Unknown error."
        case .parserError: return "Parser error data."
        case .emptyResponse: return "No objects found."
        case .missingData: return "Empty data retrieved."
        case .invalidResponse: return "Invalid response."
        case .statusCode: return "Wrong http status code."
        case .missingRequest: return "No request available"
        case .invalidRequest: return "Failed to generate request."
        case .invalidResponseObject: return "Data parsed are invalid."
        case .invalidInputParameters: return "Invalid input parameters."
        }
    }
}
