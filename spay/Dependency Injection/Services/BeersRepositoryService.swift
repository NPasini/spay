//
//  BeersRepositoryService.swift
//  spay
//
//  Created by Pasini, Nicolò on 02/09/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation
import ReactiveSwift

protocol BeersRepositoryService {
    func getBeers(page: Int, searchString: String?, maltFilter: String?) -> SignalProducer<Result<[Beer], NSError>, Never>
}

extension BeersRepositoryService {
    func getBeers(page: Int = 1, searchString: String? = nil, maltFilter: String? = nil) -> SignalProducer<Result<[Beer], NSError>, Never> {
        return getBeers(page: page, searchString: searchString, maltFilter: maltFilter)
    }
}
