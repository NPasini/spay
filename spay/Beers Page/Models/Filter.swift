//
//  Filter.swift
//  spay
//
//  Created by Pasini, Nicolò on 27/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation

class Filter {
    let filterValue: String
    private(set) var selected: Bool
    
    init(value: String) {
        selected = false
        filterValue = value
    }
    
    func changeSelection() {
        selected = !selected
    }
}

extension Filter: Equatable {
    static func == (lhs: Filter, rhs: Filter) -> Bool {
        return lhs.filterValue == rhs.filterValue
    }
}

extension Filter: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(filterValue)
    }
}
