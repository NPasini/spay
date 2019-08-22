//
//  BeersRepository.swift
//  spay
//
//  Created by Pasini, Nicolò on 21/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Result
import Foundation
import ReactiveSwift

class BeerRepository {
    let networkManager: NetworkService? = AssemblerWrapper.shared.resolve(NetworkService.self)
    
    func getBeers(page: Int = 1) -> SignalProducer<Result<[Beer], NSError>, Never> {
        let request = BeersRequest(page: page)
        return observableForGetBeers(request)
    }
    
    private func observableForGetBeers(_ request: BeersRequest) -> SignalProducer<Result<[Beer], NSError>, Never> {
        return SignalProducer {
            (observer, lifetime) in
            
            if let networkManager = self.networkManager {
                let subscription = networkManager.performApi(request, QoS: .userInteractive, completionQueue: .main) { (result: Result<BeersResponse, NSError>) in
                    
                    switch result {
                    case .success(let response):
                        observer.send(value: Result(value: response.beers))
                        observer.sendCompleted()
                    case .failure(let error):
                        observer.send(value: (Result(error: error)))
                    }
                }
                
                lifetime.observeEnded {
                    subscription.dispose()
                }
            } else {
                OSLogger.log(category: .dependencyInjection, message: "Unable to retrieve implementation of Newtork Service", access: .public, type: .debug)
                observer.send(value: Result(error: SPError(genericError: .networkServiceNotFound)))
            }
        }
    }
}
