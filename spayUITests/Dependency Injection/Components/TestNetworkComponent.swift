//
//  TestNetworkComponent.swift
//  spayUITests
//
//  Created by Pasini, Nicolò on 26/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

@testable import spay

import Foundation

class TestNetworkComponent: NetworkService {
    func performApi<T: CustomDecodable>(_ request: APIRequest<T>,
                                        QoS: QualityOfService,
                                        completionQueue: DispatchQueue = DispatchQueue.main,
                                        completion: @escaping (Result<T, NSError>) -> Void) -> APISubscriptionProtocol {
        
        let item = DispatchWorkItem {
            completion(Result(success: T.valueForTest() as! T))
        }
        
        DispatchQueue.main.sync(execute: item)
        
        return DispatchWorkItemSubscription(item: item)
    }
}
