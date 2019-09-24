//
//  BeersRepository.swift
//  spay
//
//  Created by Pasini, Nicolò on 21/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import OSLogger
import Foundation
import ReactiveSwift
import NetworkManager

class BeerRepository: BeersRepositoryService {
    //MARK: Public Functions
    func getBeers(page: Int = 1, searchString: String? = nil, maltFilter: String? = nil) -> SignalProducer<Result<[Beer], NSError>, Never> {
        let request = BeersRequest(page: page, searchString: searchString, maltFilter: maltFilter)
        return observableForGetBeers(request)
    }
    
    //MARK: Private Functions
    private func observableForGetBeers(_ request: BeersRequest) -> SignalProducer<Result<[Beer], NSError>, Never> {
        return SignalProducer {
            (observer, lifetime) in
            
            let subscription = APIPerformer.shared.performApi(request, QoS: .default, completionQueue: .global(qos: .userInteractive)) { (result: Result<BeersResponse, NSError>) in
                
                switch result {
                case .success(let response):
                    observer.send(value: Result.success(response.beers))
                    observer.sendCompleted()
                case .failure(let error):
                    observer.send(value: Result.failure(error))
                    observer.sendCompleted()
                }
            }
            
            lifetime.observeEnded {
                subscription.dispose()
            }
        }
    }
}
