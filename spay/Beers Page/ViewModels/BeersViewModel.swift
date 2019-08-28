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
    private(set) var isNewFilter: Bool = false
    private(set) var stopFetching: Bool = false
    private(set) var appliedFilter: Filter? = nil
    
    let beersDataSource: MutableProperty<[Beer]>
    
    private let beers: MutableProperty<[Beer]>
    private let searchViewModel: SearchViewModel
    private let serialDisposable: SerialDisposable
    private var beersDataSourceDisposable: Disposable?
    
    private let repository: BeerRepository = BeerRepository()
    
    init() {
        beers = MutableProperty([])
        beersDataSource = MutableProperty([])
        serialDisposable = SerialDisposable(nil)
        
        searchViewModel = SearchViewModel()
        searchViewModel.delegate = self
        
        beersDataSourceDisposable = beers.signal.observeValues({ [weak self] (newBeers: [Beer]) in
            if let isNewSearch = self?.isNewSearch, isNewSearch {
                self?.isNewSearch = false
                self?.beersDataSource.value = newBeers
                
                OSLogger.dataFlowLog(message: "Setting \(newBeers.count) new Beer Models as result of a text search", access: .public, type: .debug)
            } else if let isNewFilter = self?.isNewFilter, isNewFilter {
                self?.isNewFilter = false
                self?.beersDataSource.value = newBeers
                
                OSLogger.dataFlowLog(message: "Setting \(newBeers.count) new Beer Models as result of applying a filter", access: .public, type: .debug)
            } else {
                if let dataSource = self?.beersDataSource {
                    OSLogger.dataFlowLog(message: "Appending \(newBeers.count) new Beer Models to previous \(String(describing: dataSource.value.count)) Beer Models", access: .public, type: .debug)
                }
                
                self?.beersDataSource.value.append(contentsOf: newBeers)
            }
        })
        
        getBeers()
    }
    
    deinit {
        dispose()
    }
    
    //MARK: Public Functions
    func addFilter(_ filter: Filter) {
        if (filter != appliedFilter) {
            currentPage = 1
            isNewFilter = true
            stopFetching = false
            appliedFilter = filter
            searchViewModel.searchString = ""
        }
        
        getBeers()
    }
    
    func getBeersBy(beerName: String) {
        appliedFilter = nil
        searchViewModel.searchTextPipe.input.send(value: beerName)
    }
    
    func getBeers() {
        if (!isFetching && !stopFetching) {
            OSLogger.dataFlowLog(message: "Fetching new Beer Models from page \(currentPage)", access: .public, type: .debug)
            isFetching = true
            
            serialDisposable.inner = beers <~ repository.getBeers(page: currentPage, searchString: searchViewModel.searchString, maltFilter: appliedFilter?.filterValue).map({ [weak self] (result: Result<[Beer], NSError>) -> [Beer] in
                switch result {
                case .success(let newBeers):
                    self?.stopFetching = newBeers.count == 0 ? true : false
                    return newBeers
                case .failure:
                    return []
                }
            }).on(completed: { [weak self] in 
                self?.currentPage += 1
                self?.isFetching = false
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
        currentPage = 1
        isNewSearch = true
        stopFetching = false
        
        getBeers()
    }
}
