//
//  NetworkComponent.swift
//  lmTest
//
//  Created by Pasini, Nicolò on 27/07/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Result
import Foundation

class NetworkComponent: NetworkService {
    let apiPerformer = APIPerformer.shared
    
    func performApi<T>(_ request: APIRequest<T>, QoS: QualityOfService, completionQueue: DispatchQueue = DispatchQueue.main, completion: @escaping (Result<T, NSError>) -> Void) -> APISubscriptionProtocol where T : CustomDecodable {
        return apiPerformer.performApi(request, QoS: QoS, completionQueue: completionQueue, completion: completion)
    }
}
