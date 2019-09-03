//
//  BeersViewModel.swift
//  spay
//
//  Created by Pasini, Nicolò on 21/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation
import ReactiveSwift

typealias BoolSignal = Signal<Bool, Never>

class BeersViewModel {
    private(set) var currentPage: Int = 1
    private(set) var isFetching: Bool = false
    private(set) var isNewSearch: Bool = false
    private(set) var isNewFilter: Bool = false
    private(set) var appliedFilter: Filter? = nil
    private(set) var searchViewModel: SearchViewModel
    
    let stopFetching: Property<Bool>
    let beersDataSource: MutableProperty<[Beer]>
    
    private let beers: MutableProperty<[Beer]>
    private let serialDisposable: SerialDisposable
    private var beersDataSourceDisposable: Disposable?
    private let stopFetchingPipe: (input: BoolSignal.Observer, output: BoolSignal)
    
    private let beersRepository: BeersRepositoryService? = AssemblerWrapper.shared.resolve(BeersRepositoryService.self)
    private let filtersRepository: FiltersRepositoryService? = AssemblerWrapper.shared.resolve(FiltersRepositoryService.self)
    
    init() {
        beers = MutableProperty([])
        stopFetchingPipe = BoolSignal.pipe()
        beersDataSource = MutableProperty([])
        serialDisposable = SerialDisposable(nil)
        
        stopFetching = Property(initial: false, then: stopFetchingPipe.output)
        
        searchViewModel = SearchViewModel()
        searchViewModel.delegate = self
        
        beersDataSourceDisposable = beers.signal.observeValues({ [weak self] (newBeers: [Beer]) in
            if let isNewSearch = self?.isNewSearch, isNewSearch {
                self?.isNewSearch = false
                OSLogger.dataFlowLog(message: "Setting \(newBeers.count) new Beer Models as result of a text search", access: .public, type: .debug)
            } else if let isNewFilter = self?.isNewFilter, isNewFilter {
                self?.isNewFilter = false
                OSLogger.dataFlowLog(message: "Setting \(newBeers.count) new Beer Models as result of applying a filter", access: .public, type: .debug)
            } else {
                if let dataSource = self?.beersDataSource {
                    OSLogger.dataFlowLog(message: "Appending \(newBeers.count) new Beer Models to previous \(String(describing: dataSource.value.count)) Beer Models", access: .public, type: .debug)
                }
            }
            
            self?.beersDataSource.value.append(contentsOf: newBeers)
        })
    }
    
    deinit {
        dispose()
    }
    
    //MARK: Public Functions
    func getFilters() -> [Filter]? {
        return filtersRepository?.getFilters()
    }
    
    func getBeersWithFilter(_ filter: Filter?) {
        if (filter != appliedFilter) {
            isNewFilter = true
            appliedFilter = filter
            resetForNewResult()
        }
        
        getBeers()
    }
    
    func getBeersByNameSearch(_ beerName: String) {
        searchViewModel.searchTextPipe.input.send(value: beerName)
    }
    
    func getBeersForPage(_ page: Int) {
        currentPage = page
        isFetching = false
        stopFetchingPipe.input.send(value: false)
        
        getBeers()
    }
    
    func getBeers() {
        if (!isFetching && !stopFetching.value) {
            OSLogger.dataFlowLog(message: "Fetching new Beer Models from page \(currentPage)", access: .public, type: .debug)
            isFetching = true
            
            if let beersRepository = beersRepository {
                serialDisposable.inner = beers <~ beersRepository.getBeers(page: currentPage, searchString: searchViewModel.searchString, maltFilter: appliedFilter?.filterValue).map({ [weak self] (result: Result<[Beer], NSError>) -> [Beer] in
                    switch result {
                    case .success(let newBeers):
                        let fetchingValue = newBeers.count == 0 ? true : false
                        self?.stopFetchingPipe.input.send(value: fetchingValue)
                        return newBeers
                    case .failure:
                        return []
                    }
                }).on(completed: { [weak self] in
                    self?.currentPage += 1
                    self?.isFetching = false
                })
            }
        } else if (isFetching) {
            OSLogger.dataFlowLog(message: "Fetching already in progress for page \(currentPage)", access: .public, type: .debug)
        } else if (stopFetching.value) {
            OSLogger.dataFlowLog(message: "Fetching stopped because reached end of paged results", access: .public, type: .debug)
        }
    }
    
    //MARK: Private Functions
    private func resetForNewResult() {
        currentPage = 1
        isFetching = false
        beersDataSource.value = []
        stopFetchingPipe.input.send(value: false)
    }
    
    private func dispose() {
        OSLogger.dataFlowLog(message: "Disposing BeersViewModel", access: .public, type: .debug)
        
        if let disposable = beersDataSourceDisposable, !disposable.isDisposed {
            disposable.dispose()
        }
        
        if (!serialDisposable.isDisposed) {
            serialDisposable.dispose()
        }
    }
}

extension BeersViewModel: SearchUpdateDelegate {
    func startNewSearch() {
        isNewSearch = true
        resetForNewResult()
        getBeers()
    }
}
