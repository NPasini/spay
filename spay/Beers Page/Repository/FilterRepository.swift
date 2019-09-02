//
//  FilterRepository.swift
//  spay
//
//  Created by Pasini, Nicolò on 02/09/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation

class FilterRepository: FiltersRepositoryService {
    func getFilters() -> [Filter] {
        let f1 = Filter(value: "Munich")
        let f2 = Filter(value: "Dark Crystal")
        let f3 = Filter(value: "Caramalt")
        let f4 = Filter(value: "Wheat Malt")
        let f5 = Filter(value: "Maris Otter Extra Pale")
        
        return [f1, f2, f3 ,f4, f5]
    }
}
