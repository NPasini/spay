//
//  TestFilterRepositoryComponent.swift
//  spay
//
//  Created by Pasini, Nicolò on 02/09/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation

class TestFilterRepositoryComponent: FiltersRepositoryService {
    func getFilters() -> [Filter] {
        let f1 = Filter(value: "M1")
        let f2 = Filter(value: "M2")
        let f3 = Filter(value: "M3")
        
        return [f1, f2, f3]
    }
}
