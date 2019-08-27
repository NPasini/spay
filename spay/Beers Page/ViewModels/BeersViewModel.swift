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
    let beersModelsList: MutableProperty<[Beer]>
    
    private let beers: MutableProperty<[Beer]>
    private let searchViewModel: SearchViewModel
    private let serialDisposable: SerialDisposable
    private var addBeersModelsDisposable: Disposable?
    
    private let repository: BeerRepository = BeerRepository()

    init() {
        beers = MutableProperty([])
        searchViewModel = SearchViewModel()
        beersModelsList = MutableProperty([])
        serialDisposable = SerialDisposable(nil)
        
        searchViewModel.delegate = self
        
        addBeersModelsDisposable = beers.signal.observeValues({ (newBeers: [Beer]) in
            if (self.isNewSearch) {
                self.isNewSearch = false
                self.beersModelsList.value = newBeers
                OSLogger.dataFlowLog(message: "Setting \(newBeers.count) new Beer Models as result of a text search", access: .public, type: .debug)
            } else {
                self.beersModelsList.value.append(contentsOf: newBeers)
                OSLogger.dataFlowLog(message: "Appending \(newBeers.count) new Beer Models to previous \(String(describing: self.beersModelsList.value.count)) Beer Models", access: .public, type: .debug)
            }
        })
        
        getBeers()
    }
    
    deinit {
        dispose()
    }
    
    //MARK: Public Functions
    func getBeersBy(name: String) {
        searchViewModel.searchTextPipe.input.send(value: name)
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
