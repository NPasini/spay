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
            AssemblerWrapper.shared.register(assemblies: [TestRepositoryAssembly()])
            
            beforeEach {
                viewModel = BeersViewModel()
            }
            
            describe("a new instance of the ViewModel is created") {
                it("with the correct values of the properties") {
                    expect(viewModel.currentPage).to(equal(1))
                    expect(viewModel.appliedFilter).to(beNil())
                    expect(viewModel.isFetching).to(equal(false))
                    expect(viewModel.isNewFilter).to(equal(false))
                    expect(viewModel.isNewSearch).to(equal(false))
                    expect(viewModel.stopFetching.value).to(equal(false))
                    expect(viewModel.beersDataSource.value.count).to(equal(0))
                }
            }
            
            describe("when the ViewModel Instance is required to retrieve the next page of Beers from the API") {
                it("the ViewModel should load the first page") {
                    viewModel.getBeers()
                    
                    expect(viewModel.currentPage).to(equal(2))
                    expect(viewModel.appliedFilter).to(beNil())
                    expect(viewModel.isFetching).to(equal(false))
                    expect(viewModel.isNewFilter).to(equal(false))
                    expect(viewModel.isNewSearch).to(equal(false))
                    expect(viewModel.stopFetching.value).to(equal(false))
                    expect(viewModel.beersDataSource.value.count).to(equal(25))
                }
                
                it("the ViewModel fetches further data the next times") {
                    //Load first page
                    viewModel.getBeers()
                    
                    //Load second page
                    viewModel.getBeers()
                    expect(viewModel.currentPage).to(equal(3))
                    expect(viewModel.appliedFilter).to(beNil())
                    expect(viewModel.isFetching).to(equal(false))
                    expect(viewModel.isNewFilter).to(equal(false))
                    expect(viewModel.isNewSearch).to(equal(false))
                    expect(viewModel.stopFetching.value).to(equal(false))
                    expect(viewModel.beersDataSource.value.count).to(equal(50))
                }
                
                it("when the API returns zero results in the page, the ViewModel should stop to fetch new data") {
                    viewModel.getBeersForPage(100)
                    
                    expect(viewModel.currentPage).to(equal(101))
                    expect(viewModel.stopFetching.value).to(equal(true))
                    expect(viewModel.beersDataSource.value.count).to(equal(3))
                    
                    viewModel.getBeers()
                    expect(viewModel.currentPage).to(equal(101))
                    expect(viewModel.stopFetching.value).to(equal(true))
                    expect(viewModel.beersDataSource.value.count).to(equal(3))
                }
                
                it("when the API returns an invalid response, the ViewModel should stop to fetch new data") {
                    viewModel.getBeersForPage(101)
                    
                    expect(viewModel.currentPage).to(equal(102))
                    expect(viewModel.stopFetching.value).to(equal(true))
                    expect(viewModel.beersDataSource.value.count).to(equal(0))
                    
                    viewModel.getBeers()
                    expect(viewModel.currentPage).to(equal(102))
                    expect(viewModel.stopFetching.value).to(equal(true))
                    expect(viewModel.beersDataSource.value.count).to(equal(0))
                }
                
                it("the ViewModel should return new data after stopped fetching when the parameters of the search changes") {
                    viewModel.getBeersForPage(101)
                    
                    expect(viewModel.currentPage).to(equal(102))
                    expect(viewModel.stopFetching.value).to(equal(true))
                    expect(viewModel.beersDataSource.value.count).to(equal(0))
                    
                    viewModel.getBeersByNameSearch("test")
                    expect(viewModel.currentPage).to(equal(2))
                    expect(viewModel.stopFetching.value).to(equal(false))
                    expect(viewModel.beersDataSource.value.count).to(equal(25))
                }
            }
            
            describe("when the ViewModel Instance is required to retrieve the Beers matching a Malt filter") {
                it("the ViewModel should send a new API request amnd reset the datasource") {
                    let filter = Filter(value: "filter")
                    viewModel.getBeersWithFilter(filter)
                    
                    expect(viewModel.currentPage).to(equal(2))
                    expect(viewModel.isFetching).to(equal(false))
                    expect(viewModel.isNewFilter).to(equal(false))
                    expect(viewModel.isNewSearch).to(equal(false))
                    expect(viewModel.appliedFilter).to(equal(filter))
                    expect(viewModel.stopFetching.value).to(equal(false))
                    expect(viewModel.beersDataSource.value.count).to(equal(25))
                }
            }
            
            describe("when the ViewModel Instance is required to retrieve the Beers matching a Malt filter and a string") {
                it("the ViewModel should send a new API request") {
                    let filter = Filter(value: "filter")
                    viewModel.getBeersWithFilter(filter)
                    
                    expect(viewModel.currentPage).to(equal(2))
                    expect(viewModel.isFetching).to(equal(false))
                    expect(viewModel.isNewFilter).to(equal(false))
                    expect(viewModel.isNewSearch).to(equal(false))
                    expect(viewModel.appliedFilter).to(equal(filter))
                    expect(viewModel.stopFetching.value).to(equal(false))
                    expect(viewModel.beersDataSource.value.count).to(equal(25))
                    
                    viewModel.getBeersByNameSearch("test")
                    expect(viewModel.currentPage).to(equal(2))
                    expect(viewModel.isFetching).to(equal(false))
                    expect(viewModel.isNewFilter).to(equal(false))
                    expect(viewModel.isNewSearch).to(equal(false))
                    expect(viewModel.appliedFilter).to(equal(filter))
                    expect(viewModel.stopFetching.value).to(equal(false))
                    expect(viewModel.beersDataSource.value.count).to(equal(25))
                }
            }
        }
    }
}

