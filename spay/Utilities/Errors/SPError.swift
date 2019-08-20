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
    
    convenience init(statusError: StatusError, statusCode: Int) {
        self.init(domain: SPDomain, code: statusError.rawValue, userInfo: [NSLocalizedDescriptionKey : String(describing: statusCode)])
    }
}
