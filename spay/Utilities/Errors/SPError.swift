//
//  SPError.swift
//  spay
//
//  Created by Pasini, Nicolò on 19/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation

private let SPDomain: String = "com.sp"

class SPError: NSError {
    convenience init(networkError: NetworkError) {
        self.init(domain: SPDomain, code: networkError.rawValue, userInfo: [NSLocalizedDescriptionKey : String(describing: networkError)])
    }
    
    convenience init(genericError: GenericError) {
        self.init(domain: SPDomain, code: genericError.rawValue, userInfo: [NSLocalizedDescriptionKey : String(describing: genericError)])
    }
}
