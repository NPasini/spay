//
//  BeersTableViewTest.swift
//  spayUITests
//
//  Created by Pasini, Nicolò on 26/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import XCTest

class BeersTableViewTest: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTableViewSetDatasource() {
        let startVC = app.otherElements["BeerListViewController"]
        let tableView = startVC.tables["BeersTableView"]
        
        XCTAssertTrue(tableView.exists)
        XCTAssertTrue(tableView.cells.count == 3)
    }
    
    func testTableViewCell() {
        let startVC = app.otherElements["BeerListViewController"]
        let tableView = startVC.tables["BeersTableView"]
        let firstCell = tableView.cells.firstMatch
        
        let beerName = firstCell.staticTexts.element(matching:.any, identifier: "Name")
        XCTAssertEqual(beerName.label, "Fake Beer 1")
        
        let beerTagline = firstCell.staticTexts.element(matching:.any, identifier: "Tagline")
        XCTAssertEqual(beerTagline.label, "Fake tagline 1")
        
        let beerDescription = firstCell.staticTexts.element(matching:.any, identifier: "Description")
        XCTAssertEqual(beerDescription.label, "Fake description 1")
        
        let moreButton = firstCell.buttons["MoreInfoButton"]
        XCTAssertTrue(moreButton.exists)
    }
    
    func testTapOnCell() {
        let startVC = app.otherElements["BeerListViewController"]
        let tableView = startVC.tables["BeersTableView"]
        let firstCell = tableView.cells.firstMatch
        
        firstCell.tap()
        
        let beerDetailsView = startVC.otherElements["BeerDetailsView"]
        XCTAssertTrue(beerDetailsView.exists)
        
        let innerBeerDetailsView = beerDetailsView.otherElements["BeerDetailsView"]
        XCTAssertTrue(innerBeerDetailsView.exists)
        
        let detailsView = innerBeerDetailsView.otherElements["DetailsView"]
        XCTAssertTrue(detailsView.exists)
        
        let scrollView = detailsView.scrollViews["ScrollView"]
        XCTAssertTrue(scrollView.exists)
        
        let contentView = scrollView.otherElements["ContentView"]
        XCTAssertTrue(contentView.exists)
        
        let beerName = contentView.staticTexts["Name"]
        XCTAssertEqual(beerName.label, "Fake Beer 1")
        
        let beerTagline = contentView.staticTexts["Tagline"]
        XCTAssertEqual(beerTagline.label, "Fake tagline 1")
        
        let beerDescription = contentView.staticTexts["Description"]
        XCTAssertEqual(beerDescription.label, "Fake description 1")
    }
}

