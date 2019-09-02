//
//  BeersViewModelTest.swift
//  spayTests
//
//  Created by Pasini, Nicolò on 23/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

@testable import spay

import Quick
import Nimble
import Foundation

class BeersViewModelTest: QuickSpec {
    override func spec() {
        context("Testing the BeersViewModel") {
            var viewModel: BeersViewModel!
            
            beforeEach {
                viewModel = BeersViewModel()
            }
            
            describe("A new instance of the ViewModel is created") {
                it("With the correct values of the properties") {
                    expect(viewModel.currentPage).to(equal(1))
                    expect(viewModel.appliedFilter).to(beNil())
                    expect(viewModel.isFetching).to(equal(false))
                    expect(viewModel.isNewFilter).to(equal(false))
                    expect(viewModel.isNewSearch).to(equal(false))
                    expect(viewModel.stopFetching.value).to(equal(false))
                    expect(viewModel.beersDataSource.value.count).to(equal(0))
                }
            }
            
            describe("The ViewModel Instance is required to retrieve the next page of Beers from the API") {
                it("The ViewModel should start to load the first page") {
                    viewModel.getBeers()
                    
                    expect(viewModel.appliedFilter).to(beNil())
                    expect(viewModel.isFetching).to(equal(true))
                    expect(viewModel.isNewFilter).to(equal(false))
                    expect(viewModel.isNewSearch).to(equal(false))
                    expect(viewModel.stopFetching.value).to(equal(false))
                    
                    expect(viewModel.currentPage).toEventually(equal(2), timeout: 15)
                    expect(viewModel.isFetching).toEventually(equal(false), timeout: 15)
                    expect(viewModel.beersDataSource.value.count).toEventually(equal(25), timeout: 15)
                }
                
                it("The ViewModel fetches further data") {
                    //Load first page
                    viewModel.getBeers()
                    expect(viewModel.isFetching).toEventually(equal(false), timeout: 15)
                    
                    //Load second page
                    viewModel.getBeers()
                    expect(viewModel.appliedFilter).to(beNil())
                    expect(viewModel.isFetching).to(equal(true))
                    expect(viewModel.isNewFilter).to(equal(false))
                    expect(viewModel.isNewSearch).to(equal(false))
                    expect(viewModel.stopFetching.value).to(equal(false))
                    
                    expect(viewModel.currentPage).toEventually(equal(2), timeout: 15)
                    expect(viewModel.isFetching).toEventually(equal(false), timeout: 15)
                    expect(viewModel.beersDataSource.value.count).toEventually(equal(50), timeout: 15)
                }
                
                it("When the API returns zero results in the page, the ViewModel should stop to fetch new data") {
                    viewModel.getBeersForPage(1000)
                    
                    expect(viewModel.currentPage).toEventually(equal(1001), timeout: 15)
                    expect(viewModel.stopFetching.value).toEventually(equal(true), timeout: 15)
                }
            }
            
            describe("The ViewModel Instance is required to retrieve the Beers matching a string") {
                it("The ViewModel should start a new search") {
                    viewModel.getBeersBy(beerName: "test")

                    expect(viewModel.currentPage).to(equal(1))
                    expect(viewModel.appliedFilter).to(beNil())
                    expect(viewModel.isNewFilter).to(equal(false))
                    expect(viewModel.stopFetching.value).to(equal(false))
                    
                    expect(viewModel.currentPage).toEventually(equal(2), timeout: 15)
                    expect(viewModel.isFetching).toEventually(equal(false), timeout: 15)
                }
            }
            
            describe("The ViewModel Instance is required to retrieve the Beers matching a Malt filter") {
                it("The ViewModel should start a new search") {
                    let filter = Filter(value: "filter")
                    viewModel.applyFilter(filter)
                    
                    expect(viewModel.currentPage).to(equal(1))
                    expect(viewModel.isNewFilter).to(equal(true))
                    expect(viewModel.isNewSearch).to(equal(false))
                    expect(viewModel.stopFetching.value).to(equal(false))
                    expect(viewModel.appliedFilter).to(equal(filter))
                    
                    expect(viewModel.currentPage).toEventually(equal(2), timeout: 15)
                    expect(viewModel.isFetching).toEventually(equal(false), timeout: 15)
                }
            }
            
            describe("The ViewModel Instance is required to retrieve the Beers matching a Malt filter and a string") {
                it("The ViewModel should start a new search") {
                    let filter = Filter(value: "filter")
                    viewModel.applyFilter(filter)
                    
                    expect(viewModel.currentPage).to(equal(1))
                    expect(viewModel.isNewFilter).to(equal(true))
                    expect(viewModel.isNewSearch).to(equal(false))
                    expect(viewModel.stopFetching.value).to(equal(false))
                    expect(viewModel.appliedFilter).to(equal(filter))
                    
                    expect(viewModel.currentPage).toEventually(equal(2), timeout: 15)
                    expect(viewModel.isFetching).toEventually(equal(false), timeout: 15)
                    
                    viewModel.getBeersBy(beerName: "test")
                    expect(viewModel.isNewFilter).to(equal(false))
                    expect(viewModel.appliedFilter).to(equal(filter))
                }
            }
        }
    }
}

