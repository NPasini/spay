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
                it("when is created withouth specifying the page should contain page = 1"){
                    let request = BeersRequest()
                    
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
                
                it("when is created specifying the page"){
                    let request = BeersRequest(page: 2)
                    
                    expect(request.host).to(equal("api.punkapi.com"))
                    expect(request.version).to(equal("/v2"))
                    expect(request.path).to(equal("/beers"))
                    expect(request.queryParameters).notTo(beNil())
                    
                    if let pageParameter = request.queryParameters?["page"] as? Int {
                        expect(pageParameter).to(equal(2))
                    } else {
                        fail("Page parameter not present")
                    }
                }
            }
        }
    }
}
