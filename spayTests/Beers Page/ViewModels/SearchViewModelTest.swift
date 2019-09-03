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
            
            describe("when SearchViewModel is instantiated") {
                beforeEach {
                    searchViewModel = SearchViewModel()
                }
                
                it("the values of the properites are set to the default values") {
                    expect(searchViewModel.searchString).to(equal(""))
                }
            }
            
            describe("when a search is triggered") {
                beforeEach {
                    beersViewModel = BeersViewModel()
                }
                
                it("the search string is created and passed to the delegate") {
                    beersViewModel.getBeersByNameSearch("test string")
                    
                    expect(beersViewModel.isNewSearch).to(equal(false))
                    expect(beersViewModel.beersDataSource.value.count).to(equal(25))
                    expect(beersViewModel.searchViewModel.searchString).to(equal("test_string"))
                }
            }
        }
    }
}

