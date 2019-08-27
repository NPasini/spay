//
//  SearchViewModel.swift
//  spay
//
//  Created by Pasini, Nicolò on 27/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation
import ReactiveSwift

typealias TextSignal = Signal<String, Never>

class SearchViewModel {
    private(set) var searchString: String
    weak var delegate: SearchUpdateDelegate?
    let searchTextPipe: (output: TextSignal, input: TextSignal.Observer)
    
    private var searchDisposable: Disposable?
    
    init() {
        searchString = ""
        searchTextPipe = TextSignal.pipe()
        
        searchDisposable = searchTextPipe.output.signal.throttle(0.5, on: QueueScheduler.init(qos: .background, name: "BeersViewModel.background.queue")).observeValues({ (s: String) in
            self.searchString = s.replacingOccurrences(of: " ", with: "_")
            OSLogger.dataFlowLog(message: "Searching beers with string: \(self.searchString)", access: .public, type: .debug)
            self.delegate?.startNewSearch()
        })
    }
    
    deinit {
        dispose()
    }
    
    //MARK: Private Functions
    private func dispose() {
        OSLogger.dataFlowLog(message: "Disposing SearchViewModel", access: .public, type: .debug)
        
        if let disposable = searchDisposable, !disposable.isDisposed {
            disposable.dispose()
        }
    }
}
