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
    let beersModelsList: MutableProperty<[Beer]>
    
    private var disposable: Disposable?
    private let repository: BeerRepository
    private let beers: MutableProperty<[Beer]>
    private let serialDisposable: SerialDisposable

    init() {
        beers = MutableProperty([])
        repository = BeerRepository()
        beersModelsList = MutableProperty([])
        serialDisposable = SerialDisposable(nil)
        
        serialDisposable.inner = beers <~ repository.getBeers().map({ (result: Result<[Beer], NSError>) -> [Beer] in
            switch result {
            case .success(let newBeers):
                return newBeers
            case .failure:
                return []
            }
        })
        
        disposable = beers.signal.observeValues({ [weak self] (newBeers: [Beer]) in
            self?.beersModelsList.value.append(contentsOf: newBeers)
        })
    }
    
    func getBeers(for page: Int) {
        serialDisposable.inner = beers <~ repository.getBeers(page: page).map({ (result: Result<[Beer], NSError>) -> [Beer] in
            switch result {
            case .success(let newBeers):
                return newBeers
            case .failure:
                return []
            }
        })
    }

    func dispose() {
        if (!serialDisposable.isDisposed) {
            serialDisposable.dispose()
        }
        
        if let d = disposable, !d.isDisposed {
            d.dispose()
        }
    }

    deinit {
        dispose()
    }
}
