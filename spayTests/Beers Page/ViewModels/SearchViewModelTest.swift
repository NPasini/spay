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
    override func spec() {
        context("Testing the SearchViewModel") {
            var beersViewModel: BeersViewModel!
            var searchViewModel: SearchViewModel!
            
            AssemblerWrapper.shared.register(assemblies: [TestRepositoryAssembly()])
            
            describe("When SearchViewModel is instantiated") {
                beforeEach {
                    searchViewModel = SearchViewModel()
                }
                
                it("The values of the properites are set to the default values") {
                    expect(searchViewModel.searchString).to(equal(""))
                }
            }
            
            describe("When a search is triggered") {
                beforeEach {
                    beersViewModel = BeersViewModel()
                }
                
                it("The search string is created and passed to the delegate") {
                    beersViewModel.searchViewModel.searchTextPipe.input.send(value: "test string")
                    
                    expect(beersViewModel.isNewSearch).toEventually(equal(true), timeout: 5)
                    expect(beersViewModel.searchViewModel.searchString).toEventually(equal("test_string"), timeout: 1)
                }
            }
            
            describe("when the SearchViewModel Instance is required to retrieve the Beers matching a string") {
                it("the BeersViewModel should send a new API request") {
                    beersViewModel.getBeersBy(beerName: "test")
                    
                    expect(beersViewModel.isNewSearch).toEventually(equal(true), timeout: 1)
                    expect(beersViewModel.beersDataSource.value.count).toEventually(equal(3), timeout: 1)
                    expect(beersViewModel.searchViewModel.searchString).toEventually(equal("test"), timeout: 1)
                }
            }
        }
    }
}

