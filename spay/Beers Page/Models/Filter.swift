//
//  Filter.swift
//  spay
//
//  Created by Pasini, Nicolò on 27/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation

enum MaltFilterValue: Int {
    case oneMalt = 1
    case twoMalts = 2
    case threeMalts = 3
    case fourOrMoreMalts = 4
    
    var filterText: String {
        switch self {
        case .oneMalt:
            return "1 Malt"
        case .twoMalts:
            return "2 Malts"
        case .threeMalts:
            return "3 Malts"
        case .fourOrMoreMalts:
            return "4 Malts"
        }
    }
}

class Filter {
    private(set) var selected: Bool
    let filterValue: MaltFilterValue
    
    init(value: MaltFilterValue) {
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
