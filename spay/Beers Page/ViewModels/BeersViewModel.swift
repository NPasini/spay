//
//  BeersViewModel.swift
//  spay
//
//  Created by Pasini, Nicolò on 21/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation
import ReactiveSwift

class BeersViewModel {
    private(set) var currentPage: Int = 1
    private(set) var isFetching: Bool = false
    private(set) var isNewSearch: Bool = false
    private(set) var stopFetching: Bool = false
    private(set) var appliedFilters: Set<Filter> = Set<Filter>()
    
    let beersDataSource: MutableProperty<[Beer]>
    let beersCompleteList: MutableProperty<[Beer]>
    
    private let beers: MutableProperty<[Beer]>
    private let searchViewModel: SearchViewModel
    private let filterViewModel: FilterViewModel
    private let serialDisposable: SerialDisposable
    private var addBeersModelsDisposable: Disposable?
    private var beersDataSourceDisposable: Disposable?
    
    private let repository: BeerRepository = BeerRepository()
    
    init() {
        beers = MutableProperty([])
        beersDataSource = MutableProperty([])
        beersCompleteList = MutableProperty([])
        serialDisposable = SerialDisposable(nil)
        
        filterViewModel = FilterViewModel()
        searchViewModel = SearchViewModel()
        searchViewModel.delegate = self
        
        addBeersModelsDisposable = beers.signal.observeValues({ (newBeers: [Beer]) in
            if (self.isNewSearch) {
                self.isNewSearch = false
                self.beersCompleteList.value = newBeers
                OSLogger.dataFlowLog(message: "Setting \(newBeers.count) new Beer Models as result of a text search", access: .public, type: .debug)
            } else {
                self.beersCompleteList.value.append(contentsOf: newBeers)
                OSLogger.dataFlowLog(message: "Appending \(newBeers.count) new Beer Models to previous \(String(describing: self.beersCompleteList.value.count)) Beer Models", access: .public, type: .debug)
            }
        })
        
        let completeBeersListSignalProducer = beersCompleteList.producer.map({ (beers: [Beer]) -> [Beer] in
            if (self.appliedFilters.count > 0) {
                return self.filterViewModel.filterBeersList(beers: beers, filters: self.appliedFilters)
            } else {
                return beers
            }
        })
        
        beersDataSourceDisposable = beersDataSource <~ SignalProducer.merge([completeBeersListSignalProducer, filterViewModel.filterSignalProducer]).on(value: { (beers: [Beer]) in
            if (beers.count < 10) {
                self.currentPage += 1
                self.isFetching = false
                self.getBeers()
            }
        })
        
        getBeers()
    }
    
    deinit {
        dispose()
    }
    
    //MARK: Public Functions
    func addFilter(_ filter: Filter) {
        appliedFilters.insert(filter)
        filterViewModel.filterPipe.input.send(value: (appliedFilters, beersCompleteList.value))
    }
    
    func removeFilter(_ filter: Filter) {
        appliedFilters.remove(filter)
        filterViewModel.filterPipe.input.send(value: (appliedFilters, beersCompleteList.value))
    }
    
    func getBeersBy(beerName: String) {
        searchViewModel.searchTextPipe.input.send(value: beerName)
    }
    
    func getBeers() {
        if (!isFetching && !stopFetching) {
            OSLogger.dataFlowLog(message: "Fetching new Beer Models from page \(currentPage)", access: .public, type: .debug)
            isFetching = true
            
            serialDisposable.inner = beers <~ repository.getBeers(page: currentPage, searchString: searchViewModel.searchString).map({ (result: Result<[Beer], NSError>) -> [Beer] in
                switch result {
                case .success(let newBeers):
                    self.stopFetching = newBeers.count == 0 ? true : false
                    return newBeers
                case .failure:
                    return []
                }
            }).on(completed: {
                self.currentPage += 1
                self.isFetching = false
            })
        } else if (isFetching) {
            OSLogger.dataFlowLog(message: "Fetching already in progress for page \(currentPage)", access: .public, type: .debug)
        } else if (stopFetching) {
            OSLogger.dataFlowLog(message: "Fetching stopped because reached end of paged results", access: .public, type: .debug)
        }
    }
    
    //MARK: Private Functions
    private func dispose() {
        OSLogger.dataFlowLog(message: "Disposing BeersViewModel", access: .public, type: .debug)
        
        if let disposable = addBeersModelsDisposable, !disposable.isDisposed {
            disposable.dispose()
        }
        
        if (!serialDisposable.isDisposed) {
            serialDisposable.dispose()
        }
    }
}

extension BeersViewModel: SearchUpdateDelegate {
    func startNewSearch() {
        currentPage = 1
        isNewSearch = true
        stopFetching = false
        getBeers()
    }
}
