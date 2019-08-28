//
//  BeersRequestTest.swift
//  spayTests
//
//  Created by Pasini, Nicolò on 21/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

@testable import spay

import Quick
import Nimble
import Foundation

class BeersRequestTest: QuickSpec {
    override func spec() {
        context("Testing the Get Beers API request"){
            describe("An istance of the request should contain correct endpoint and parameters"){
                it("when is created specifying the page"){
                    let request = BeersRequest(page: 1, searchString: nil, maltFilter: nil)
                    
                    expect(request.host).to(equal("api.punkapi.com"))
                    expect(request.version).to(equal("/v2"))
                    expect(request.path).to(equal("/beers"))
                    expect(request.queryParameters).notTo(beNil())
                    
                    if let pageParameter = request.queryParameters?["page"] as? Int {
                        expect(pageParameter).to(equal(1))
                    } else {
                        fail("Page parameter not present")
                    }
                }
                
                it("when is created specifying the page and the search string"){
                    let request = BeersRequest(page: 1, searchString: "test search", maltFilter: nil)
                    
                    expect(request.host).to(equal("api.punkapi.com"))
                    expect(request.version).to(equal("/v2"))
                    expect(request.path).to(equal("/beers"))
                    expect(request.queryParameters).notTo(beNil())
                    
                    if let pageParameter = request.queryParameters?["page"] as? Int {
                        expect(pageParameter).to(equal(1))
                    } else {
                        fail("Page parameter not present")
                    }
                    
                    if let pageParameter = request.queryParameters?["beer_name"] as? String {
                        expect(pageParameter).to(equal("test_search"))
                    } else {
                        fail("Page parameter not present")
                    }
                }
                
                it("when is created specifying the page and the filter on the malt"){
                    let request = BeersRequest(page: 1, searchString: nil, maltFilter: "test filter")
                    
                    expect(request.host).to(equal("api.punkapi.com"))
                    expect(request.version).to(equal("/v2"))
                    expect(request.path).to(equal("/beers"))
                    expect(request.queryParameters).notTo(beNil())
                    
                    if let pageParameter = request.queryParameters?["page"] as? Int {
                        expect(pageParameter).to(equal(1))
                    } else {
                        fail("Page parameter not present")
                    }
                    
                    if let pageParameter = request.queryParameters?["malt"] as? String {
                        expect(pageParameter).to(equal("test_filter"))
                    } else {
                        fail("Page parameter not present")
                    }
                }
            }
        }
    }
}
