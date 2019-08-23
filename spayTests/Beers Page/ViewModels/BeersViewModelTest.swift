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
        context("Testing the BeersViewModel"){
            let viewModel = BeersViewModel()
            
            describe("A new instance of the ViewModel is created"){
                it("The fisrt beer page should be retrieve"){
                    expect(viewModel.beersModelsList.value.count).toEventually(equal(25), timeout: 1)
                }
            }
            
            describe("The ViewModel Instance is required to retrieve the next page of Beers from the API") {
                beforeEach {
                    viewModel.getBeers(for: 2)
                }
                
                it("The new Beer Models should be added to the property beersModelsList") {
                    expect(viewModel.beersModelsList.value.count).toEventually(equal(50), timeout: 30)
                }
            }
        }
    }
}

