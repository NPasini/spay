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
    private(set) var isFetching: Bool
    private(set) var currentPage: Int
    let beersModelsList: MutableProperty<[Beer]>
    
    private let repository: BeerRepository
    private let beers: MutableProperty<[Beer]>
    private let serialDisposable: SerialDisposable
    private var addBeersModelsdisposable: Disposable?

    init() {
        currentPage = 1
        isFetching = false
        beers = MutableProperty([])
        repository = BeerRepository()
        beersModelsList = MutableProperty([])
        serialDisposable = SerialDisposable(nil)
        
        addBeersModelsdisposable = beers.signal.observeValues({ [weak self] (newBeers: [Beer]) in
            self?.currentPage += 1
            self?.isFetching = false
            OSLogger.dataFlowLog(message: "Appending \(newBeers.count) new Beer Models to previous \(String(describing: self?.beersModelsList.value.count)) Beer Models", access: .public, type: .debug)
            self?.beersModelsList.value.append(contentsOf: newBeers)
        })
        
        getBeers()
    }
    
    deinit {
        dispose()
    }
    
    //MARK: Public Functions
    func getBeers() {
        let message = isFetching ? "Fetching already in progress for page \(currentPage)" : "Fetching new Beer Models from page \(currentPage)"
        OSLogger.dataFlowLog(message: message, access: .public, type: .debug)
        
        if (!isFetching) {
            isFetching = true
            
            serialDisposable.inner = beers <~ repository.getBeers(page: currentPage).map({ (result: Result<[Beer], NSError>) -> [Beer] in
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
        
        if let disposable = addBeersModelsdisposable, !disposable.isDisposed {
            disposable.dispose()
        }
        
        if (!serialDisposable.isDisposed) {
            serialDisposable.dispose()
        }
    }
}
