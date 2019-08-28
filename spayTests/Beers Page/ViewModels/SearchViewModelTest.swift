//
//  SearchViewModelTest.swift
//  spayTests
//
//  Created by Pasini, Nicolò on 28/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

@testable import spay

import Quick
import Nimble
import Foundation

class SearchViewModelTest: QuickSpec {
    private class FakeDelegate: SearchUpdateDelegate {
        var delegateTriggered: Bool = false
        
        func startNewSearch() {
            delegateTriggered = true
        }
    }
    
    override func spec() {
        context("Testing the BeersViewModel") {
            var fakeDelegate: FakeDelegate!
            var searchViewModel: SearchViewModel!
            
            describe("When BeersViewModel is instantiated") {
                beforeEach {
                    searchViewModel = SearchViewModel()
                }
                
                it("The values of the properites are set to the default values") {
                    expect(searchViewModel.searchString).to(equal(""))
                }
            }
            
            describe("When a search is triggered") {
                beforeEach {
                    fakeDelegate = FakeDelegate()
                    searchViewModel = SearchViewModel()
                    searchViewModel.delegate = fakeDelegate
                }
                
                it("The search string is created and passed to the delegate") {
                    searchViewModel.searchTextPipe.input.send(value: "test string")
                    
                    expect(searchViewModel.searchString).toEventually(equal("test_string"), timeout: 1)
                    expect(fakeDelegate.delegateTriggered).toEventually(equal(true), timeout: 1)
                }
            }
        }
    }
}

