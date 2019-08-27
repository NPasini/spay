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
        context("Testing the Get Beers API response"){
            describe("The response should not be decoded"){
                it("with empty data"){
                    let response = BeersResponse.decode(Data())
                    expect(response).to(beNil())
                }
            }
            
            describe("The response should be decoded") {
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
                    
                    if let beersResponse = response as? BeersResponse {
                        expect(beersResponse.beers.count).to(equal(25))
                        
                        for beer: Beer in beersResponse.beers {
                            expect(beer.id).notTo(beNil())
                            expect(beer.name).notTo(beNil())
                            expect(beer.tagline).notTo(beNil())
                            expect(beer.description).notTo(beNil())
                        }
                    }
                }
            }
            
            describe("The response should not be decoded") {
                it("with a json where all the Beer objects have not all the fields"){
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
        }
        
        context("The ApiPerfomer with BeersRequest"){
            var apiSubscriptionProtocol: APISubscriptionProtocol? = nil
            
            AssemblerWrapper.shared.register(assemblies: [NetworkAssembly()])
            
            afterEach {
                apiSubscriptionProtocol?.dispose()
                apiSubscriptionProtocol = nil
            }
            
            describe("should retrieve value"){
                it("if response json is an array"){
                    let request = BeersRequest(page: 1, searchString: nil)
                    let networkDispatcher: NetworkService? = AssemblerWrapper.shared.resolve(NetworkService.self)
                    
                    waitUntil(timeout: 5) { done in
                        apiSubscriptionProtocol = networkDispatcher?.performApi(request, QoS: .background, completion: { (result) in
                            
                            switch result {
                            case .success(let value):
                                expect(value).toNot(beNil())
                                expect(value.beers.count).to(equal(25))
                            case .failure(_):
                                fail("Error when performing Beers API")
                            }
                            
                            done()
                        })
                    }
                }
                
                it("if response json is an array and the search string is not empty"){
                    let request = BeersRequest(page: 1, searchString: "test")
                    let networkDispatcher: NetworkService? = AssemblerWrapper.shared.resolve(NetworkService.self)
                    
                    waitUntil(timeout: 5) { done in
                        apiSubscriptionProtocol = networkDispatcher?.performApi(request, QoS: .background, completion: { (result) in
                            
                            switch result {
                            case .success(let value):
                                expect(value).toNot(beNil())
                                expect(value.beers.count).to(beGreaterThanOrEqualTo(0))
                            case .failure(_):
                                fail("Error when performing Beers API")
                            }
                            
                            done()
                        })
                    }
                }
            }
        }
    }
}

