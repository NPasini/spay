//
//  NetworkService.swift
//  spay
//
//  Created by Pasini, Nicolò on 20/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Result
import Foundation

protocol NetworkService {
    func performApi<T: CustomDecodable>(_ request: APIRequest<T>, QoS: QualityOfService, completionQueue: DispatchQueue, completion: @escaping (Result<T, NSError>) -> Void) -> APISubscriptionProtocol
}

extension NetworkService {
    func performApi<T: CustomDecodable>(_ request: APIRequest<T>, QoS: QualityOfService, completionQueue: DispatchQueue = DispatchQueue.main, completion: @escaping (Result<T, NSError>) -> Void) -> APISubscriptionProtocol {
        return performApi(request, QoS: QoS, completionQueue: completionQueue, completion: completion)
    }
}
