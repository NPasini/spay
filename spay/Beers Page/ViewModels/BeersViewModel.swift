//
//  BeersViewModel.swift
//  spay
//
//  Created by Pasini, Nicolò on 21/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation
import ReactiveSwift

typealias TextSignal = Signal<String, Never>

class BeersViewModel {
    private(set) var isFetching: Bool
    private(set) var currentPage: Int
    let beersModelsList: MutableProperty<[Beer]>
    let searchTextPipe: (input: TextSignal.Observer, output: TextSignal)
    
    private var searchString: String
    private let repository: BeerRepository
    private var searchDisposable: Disposable?
    private let beers: MutableProperty<[Beer]>
    private let serialDisposable: SerialDisposable
    private var addBeersModelsDisposable: Disposable?

    init() {
        currentPage = 1
        searchString = ""
        isFetching = false
        beers = MutableProperty([])
        repository = BeerRepository()
        searchTextPipe = TextSignal.pipe()
        beersModelsList = MutableProperty([])
        serialDisposable = SerialDisposable(nil)
        
        addBeersModelsDisposable = beers.signal.observeValues({ (newBeers: [Beer]) in
            self.currentPage += 1
            self.isFetching = false
            
            //IF filter replace
            
            OSLogger.dataFlowLog(message: "Appending \(newBeers.count) new Beer Models to previous \(String(describing: self.beersModelsList.value.count)) Beer Models", access: .public, type: .debug)
            self.beersModelsList.value.append(contentsOf: newBeers)
            
            //If not filter append
        })
        
        searchDisposable = searchTextPipe.output.signal.observeValues({ (s: String) in
            let searchString = s.replacingOccurrences(of: " ", with: "_")
            self.currentPage = 1
            self.getBeers(searchString: searchString)
        })
        
        getBeers()
    }
    
    deinit {
        dispose()
    }
    
    //MARK: Public Functions
    func getBeers(searchString: String? = nil) {
        let message = isFetching ? "Fetching already in progress for page \(currentPage)" : "Fetching new Beer Models from page \(currentPage)"
        OSLogger.dataFlowLog(message: message, access: .public, type: .debug)
        
        if (!isFetching) {
            isFetching = true
            
            serialDisposable.inner = beers <~ repository.getBeers(page: currentPage, searchString: searchString).map({ (result: Result<[Beer], NSError>) -> [Beer] in
                switch result {
                case .success(let newBeers):
                    return newBeers
                case .failure:
                    return []
                }
            })
        }
    }

    //MARK: Private Functions
    private func dispose() {
        OSLogger.dataFlowLog(message: "Disposing ViewModel", access: .public, type: .debug)
        
        if let disposable1 = searchDisposable, !disposable1.isDisposed {
            disposable1.dispose()
        }
        
        if let disposable2 = addBeersModelsDisposable, !disposable2.isDisposed {
            disposable2.dispose()
        }
        
        if (!serialDisposable.isDisposed) {
            serialDisposable.dispose()
        }
    }
}
