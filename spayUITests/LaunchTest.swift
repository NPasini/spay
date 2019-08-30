//
//  spayUITests.swift
//  spayUITests
//
//  Created by Pasini, Nicolò on 18/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import XCTest

class LaunchTest: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        
        app.launch()
    }

    func testLaunch() {
        let startVC = app.otherElements["BeerListViewController"]
        XCTAssertTrue(startVC.exists)
        
        //TableView visible
        let tableView = startVC.tables["BeersTableView"]
        XCTAssertTrue(tableView.exists)
        
        //SearchBar visible
        let searchView = startVC.otherElements["SearchBar"]
        XCTAssertTrue(searchView.exists)
        
        //OffersView visible
        let offersView = startVC.otherElements["OffersView"]
        XCTAssertTrue(offersView.exists)
        let offerName = offersView.staticTexts.element(matching:.any, identifier: "OfferTitle")
        let offerDescription = offersView.staticTexts.element(matching:.any, identifier: "OfferDescription")
        XCTAssertTrue(offerName.exists)
        XCTAssertEqual(offerName.label, "Weekend Offers")
        XCTAssertTrue(offerDescription.exists)
        XCTAssertEqual(offerDescription.label, "Free shipping on orders over 60€")
        
        //FilterView visible
        let collectionView = startVC.collectionViews["FiltersCollectionView"]
        XCTAssertTrue(collectionView.exists)
    }
}
