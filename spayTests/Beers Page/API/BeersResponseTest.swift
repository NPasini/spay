//
//  BeersResponseTest.swift
//  spayTests
//
//  Created by Pasini, Nicolò on 20/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

@testable import spay

import Quick
import Nimble
import Foundation

class BeersResponseTest: QuickSpec {
    override func spec() {
        context("Testing the Get Beers API response") {
            describe("the response should not be decoded"){
                it("with empty data"){
                    let response = BeersResponse.decode(Data())
                    expect(response).to(beNil())
                }
            }
            
            describe("the response should be decoded") {
                it("with correct json to parse"){
                    let path = Bundle(for: type(of: self)).path(forResource: "beersResponse", ofType: "json") ?? ""
                    let data = (try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe))
                    
                    guard let dataObject = data else {
                        fail("Wrong json file path")
                        return
                    }
                    
                    let response = BeersResponse.decode(dataObject)
                    expect(response).notTo(beNil())
                    expect(response).to(beAnInstanceOf(BeersResponse.self))
                    
                    let beersResponse = response as! BeersResponse
                    expect(beersResponse.beers.count).to(equal(25))
                    
                    for beer: Beer in beersResponse.beers {
                        expect(beer.id).notTo(beNil())
                        expect(beer.name).notTo(beNil())
                        expect(beer.tagline).notTo(beNil())
                        expect(beer.description).notTo(beNil())
                    }
                }
            }
            
            describe("the response should not be decoded") {
                it("with a json where all the Beer objects have not all the mandatory fields"){
                    let path = Bundle(for: type(of: self)).path(forResource: "beersIncompleteResponse", ofType: "json") ?? ""
                    let data = (try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe))
                    
                    guard let dataObject = data else {
                        fail("Wrong json file path")
                        return
                    }
                    
                    let response = BeersResponse.decode(dataObject)
                    expect(response).to(beNil())
                }
            }
            
            describe("the following beers model should be decoded") {
                it("with a json where there is only a beer with empty malts array"){
                    let path = Bundle(for: type(of: self)).path(forResource: "oneBeerWithNoMalts", ofType: "json") ?? ""
                    let data = (try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe))
                    
                    guard let dataObject = data else {
                        fail("Wrong json file path")
                        return
                    }
                    
                    let response = BeersResponse.decode(dataObject)
                    expect(response).toNot(beNil())
                    
                    let beersResponse = response as! BeersResponse
                    expect(beersResponse.beers.count).to(equal(1))
                    
                    let beer = beersResponse.beers[0]
                    expect(beer.id).to(equal(1))
                    expect(beer.imageUrl).to(beNil())
                    expect(beer.name).to(equal("Buzz"))
                    expect(beer.hops.count).to(equal(5))
                    expect(beer.malts.count).to(equal(0))
                    expect(beer.yeast).to(equal("Wyeast 1056 - American Ale™"))
                    expect(beer.tagline).to(equal("A Real Bitter Experience."))
                    expect(beer.description).to(equal("A light, crisp and bitter IPA brewed with English and American hops. A small batch brewed only once."))
                }
            }
            
            describe("the following beers model should be decoded") {
                it("with a json where there is only a beer with empty hops array"){
                    let path = Bundle(for: type(of: self)).path(forResource: "oneBeerWithNoHops", ofType: "json") ?? ""
                    let data = (try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe))
                    
                    guard let dataObject = data else {
                        fail("Wrong json file path")
                        return
                    }
                    
                    let response = BeersResponse.decode(dataObject)
                    expect(response).toNot(beNil())
                    
                    let beersResponse = response as! BeersResponse
                    expect(beersResponse.beers.count).to(equal(1))
                    
                    let beer = beersResponse.beers[0]
                    expect(beer.id).to(equal(1))
                    expect(beer.imageUrl).to(beNil())
                    expect(beer.name).to(equal("Buzz"))
                    expect(beer.hops.count).to(equal(0))
                    expect(beer.malts.count).to(equal(3))
                    expect(beer.yeast).to(equal("Wyeast 1056 - American Ale™"))
                    expect(beer.tagline).to(equal("A Real Bitter Experience."))
                    expect(beer.description).to(equal("A light, crisp and bitter IPA brewed with English and American hops. A small batch brewed only once."))
                }
            }
            
            describe("the following beers model should be decoded") {
                it("with a json where there is only a beer with null yeats"){
                    let path = Bundle(for: type(of: self)).path(forResource: "oneBeerWithNoYeats", ofType: "json") ?? ""
                    let data = (try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe))
                    
                    guard let dataObject = data else {
                        fail("Wrong json file path")
                        return
                    }
                    
                    let response = BeersResponse.decode(dataObject)
                    expect(response).toNot(beNil())
                    
                    let beersResponse = response as! BeersResponse
                    expect(beersResponse.beers.count).to(equal(1))
                    
                    let beer = beersResponse.beers[0]
                    expect(beer.id).to(equal(1))
                    expect(beer.yeast).to(beNil())
                    expect(beer.imageUrl).to(beNil())
                    expect(beer.name).to(equal("Buzz"))
                    expect(beer.hops.count).to(equal(5))
                    expect(beer.malts.count).to(equal(3))
                    expect(beer.tagline).to(equal("A Real Bitter Experience."))
                    expect(beer.description).to(equal("A light, crisp and bitter IPA brewed with English and American hops. A small batch brewed only once."))
                }
            }
        }
    }
}

