//
//  GenericError.swift
//  spay
//
//  Created by Pasini, Nicolò on 22/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation

enum GenericError: Int, Error {
    case networkServiceNotFound
    
    var description: String {
        switch self {
        case .networkServiceNotFound: return "Network Service implementation was not retrieved by DI."
        }
    }
}
