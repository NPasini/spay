//
//  FiltersRepositoryService.swift
//  spay
//
//  Created by Pasini, Nicolò on 02/09/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation

protocol FiltersRepositoryService {
    func getFilters() -> [Filter]
}
