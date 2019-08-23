//
//  BeersViewModel.swift
//  spay
//
//  Created by Pasini, Nicolò on 21/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation
import ReactiveSwift

typealias BeersSignal = Signal<Result<[Beer], NSError>, Never>

class BeersViewModel {
    let beersModelsList: MutableProperty<[Beer]>
    
    private var disposable: Disposable?
    private let repository: BeerRepository
    private let serialDisposable: SerialDisposable
    private let beersSignalPipe: (output: BeersSignal, input: BeersSignal.Observer)

    init() {
        repository = BeerRepository()
        beersSignalPipe = BeersSignal.pipe()
        beersModelsList = MutableProperty([])
        serialDisposable = SerialDisposable(nil)
        
        serialDisposable.inner = repository.getBeers().start(beersSignalPipe.input)
        
        disposable = beersSignalPipe.output.signal.observeValues { [weak self] (result: Result<[Beer], NSError>) in
            switch result {
            case .success(let newBeers):
                self?.beersModelsList.value.append(contentsOf: newBeers)
            case .failure:
               break
            }
        }
    }
    
    //MARK: Public Functions
    func getBeers(for page: Int) {
        serialDisposable.inner = repository.getBeers(page: page).start(beersSignalPipe.input)
    }

    //MARK: Private Functions
    private func dispose() {
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
