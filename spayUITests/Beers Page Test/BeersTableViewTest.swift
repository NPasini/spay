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
    
    func testTableViewSetDatasource() {
        let startVC = app.otherElements["BeerListViewController"]
        let tableView = startVC.tables["BeersTableView"]
        
        XCTAssertTrue(tableView.exists)
        XCTAssertEqual(tableView.cells.count, 3)
    }
    
    func testTableViewCell() {
        let startVC = app.otherElements["BeerListViewController"]
        let tableView = startVC.tables["BeersTableView"]
        
        //Check first mocked Beer
        let firstCell = tableView.cells.firstMatch
        let beerName = firstCell.staticTexts.element(matching:.any, identifier: "Name")
        XCTAssertEqual(beerName.label, "Fake Beer 1")
        
        let beerTagline = firstCell.staticTexts.element(matching:.any, identifier: "Tagline")
        XCTAssertEqual(beerTagline.label, "Fake tagline 1")
        
        let beerDescription = firstCell.staticTexts.element(matching:.any, identifier: "Description")
        XCTAssertEqual(beerDescription.label, "Fake description 1")
        
        let moreButton = firstCell.buttons["MoreInfoButton"]
        XCTAssertTrue(moreButton.exists)
        
        //Swipe
        tableView.swipeUp()
        
        //Check last mocked Beer
        let lastCell = tableView.cells.containing(.staticText, identifier: "Fake Beer 3")
        
        let lastCellName = lastCell.staticTexts.element(matching:.any, identifier: "Name")
        XCTAssertEqual(lastCellName.label, "Fake Beer 3")
        
        let lastCellTagline = lastCell.staticTexts.element(matching:.any, identifier: "Tagline")
        XCTAssertEqual(lastCellTagline.label, "Fake tagline 3")
        
        let lastCellDescription = lastCell.staticTexts.element(matching:.any, identifier: "Description")
        XCTAssertEqual(lastCellDescription.label, "Fake description 3")
        
        let lastCellMoreButton = lastCell.buttons["MoreInfoButton"]
        XCTAssertTrue(lastCellMoreButton.exists)
    }
    
    func testTapOnShowMore() {
        let startVC = app.otherElements["BeerListViewController"]
        let tableView = startVC.tables["BeersTableView"]
        let firstCell = tableView.cells.firstMatch
        let showMoreButton = firstCell.buttons["MoreInfoButton"]
        
        showMoreButton.tap()
        
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
        
        let beerName = contentView.staticTexts["BeerName"]
        XCTAssertEqual(beerName.label, "Fake Beer 1")
        
        let beerTagline = contentView.staticTexts["BeerTagline"]
        XCTAssertEqual(beerTagline.label, "Fake tagline 1")
        
        let beerDescription = contentView.staticTexts["BeerDescription"]
        XCTAssertEqual(beerDescription.label, "Fake description 1")
        
        let beerMalts = contentView.staticTexts["BeerMalts"]
        XCTAssertEqual(beerMalts.label, "Malts\nM1 10.0 kg")
        
        let beerHops = contentView.staticTexts["BeerHops"]
        XCTAssertEqual(beerHops.label, "Hops\nH1 20.0 grams")
        
        let beerYeat = contentView.staticTexts["BeerYeast"]
        XCTAssertEqual(beerYeat.label, "Yeast\nY1")
    }
    
    func testCloseBeerDetails() {
        let startVC = app.otherElements["BeerListViewController"]
        let tableView = startVC.tables["BeersTableView"]
        let firstCell = tableView.cells.firstMatch
        let showMoreButton = firstCell.buttons["MoreInfoButton"]
        
        showMoreButton.tap()
        
        let beerDetailsView = startVC.otherElements["BeerDetailsView"]
        XCTAssertTrue(beerDetailsView.exists)
        
        let overlay = beerDetailsView.otherElements["TopOverlay"]
        XCTAssertTrue(overlay.exists)
        
        overlay.tap()
        
        XCTAssertFalse(beerDetailsView.exists)
    }
}

