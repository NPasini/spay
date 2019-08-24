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
            let viewModel = BeersViewModel()
            
            describe("A new instance of the ViewModel is created") {
                it("The fisrt beer page should be retrieved") {
                    expect(viewModel.currentPage).to(equal(1))
                    expect(viewModel.isFetching).to(equal(true))
                    expect(viewModel.beersModelsList.value.count).to(equal(0))
                }
                
                it("When the API endpoint returns a response the Beers Models List should be updated with the values") {
                    expect(viewModel.currentPage).toEventually(equal(2), timeout: 15)
                    expect(viewModel.isFetching).toEventually(equal(false), timeout: 15)
                    expect(viewModel.beersModelsList.value.count).toEventually(equal(25), timeout: 15)
                }
            }
            
            describe("The ViewModel Instance is required to retrieve the next page of Beers from the API") {
                it("The ViewModel should start to fetch the new data") {
                    viewModel.getBeers()
                    
                    expect(viewModel.currentPage).to(equal(2))
                    expect(viewModel.isFetching).to(equal(true))
                    expect(viewModel.beersModelsList.value.count).to(equal(25))
                }
                
                it("When the API endpoint returns a response, the new Beer Models should be added to the property beersModelsList") {
                    expect(viewModel.currentPage).toEventually(equal(2), timeout: 15)
                    expect(viewModel.isFetching).toEventually(equal(false), timeout: 15)
                    expect(viewModel.beersModelsList.value.count).toEventually(equal(50), timeout: 15)
                }
            }
        }
    }
}

