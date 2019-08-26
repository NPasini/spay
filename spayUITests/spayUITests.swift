//
//  spayUITests.swift
//  spayUITests
//
//  Created by Pasini, Nicolò on 18/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import XCTest

class spayUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLaunch() {
        let startVC = app.otherElements["BeerListViewController"]
        XCTAssertTrue(startVC.exists)
        
        //TableView
        XCTAssertEqual(startVC.tables.count, 1)
        let tableView = startVC.tables["BeersTableView"]
        XCTAssertTrue(tableView.exists)
        
        //SearchBar
        let searchView = startVC.otherElements["SearchBar"]
        XCTAssertTrue(searchView.exists)
        
        //OffersView
        let offersView = startVC.otherElements["OffersView"]
        XCTAssertTrue(offersView.exists)
        let offerName = offersView.staticTexts.element(matching:.any, identifier: "OfferTitle")
        let offerDescription = offersView.staticTexts.element(matching:.any, identifier: "OfferDescription")
        XCTAssertTrue(offerName.exists)
        XCTAssertEqual(offerName.label, "Weekend Offers")
        XCTAssertTrue(offerDescription.exists)
        XCTAssertEqual(offerDescription.label, "Free shipping on orders over 60€")
        
        //FilterView
        XCTAssertEqual(startVC.collectionViews.count, 1)
        let collectionView = startVC.collectionViews["FiltersCollectionView"]
        XCTAssertTrue(collectionView.exists)
    }
}
