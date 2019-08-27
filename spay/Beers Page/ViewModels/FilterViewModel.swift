//
//  FilterViewModel.swift
//  spay
//
//  Created by Pasini, Nicolò on 27/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation
import ReactiveSwift

typealias FilterSignal = Signal<(Set<Filter>, [Beer]), Never>

class FilterViewModel {
    let filterPipe: (input: FilterSignal.Observer, output: FilterSignal)
    
    var filterSignalProducer: SignalProducer<[Beer], Never> {
        get {
            return filterPipe.output.producer.map({ (filters: Set<Filter>, beers: [Beer]) -> [Beer] in
                if (filters.count > 0) {
                    return self.filterBeersList(beers: beers, filters: filters)
                } else {
                    return beers
                }
            })
        }
    }
    
    init() {
        filterPipe = FilterSignal.pipe()
    }
    
    //MARK: Public Functions
    public func filterBeersList(beers: [Beer], filters: Set<Filter>) -> [Beer] {
        return beers.filter({ (b: Beer) -> Bool in
            var isConformToFilters: Bool = false
            switch (b.malts.count) {
            case 0: ()
            case 1:
                if (filters.contains(Filter(value: .oneMalt))) {
                    isConformToFilters = true
                }
            case 2:
                if (filters.contains(Filter(value: .twoMalts))) {
                    isConformToFilters = true
                }
            case 3:
                if (filters.contains(Filter(value: .threeMalts))) {
                    isConformToFilters = true
                }
            default:
                if (filters.contains(Filter(value: .fourOrMoreMalts))) {
                    isConformToFilters = true
                }
            }
            return isConformToFilters
        })
    }
}
