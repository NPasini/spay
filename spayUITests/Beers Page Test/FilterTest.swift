//
//  FilterTest.swift
//  spayUITests
//
//  Created by Pasini, Nicolò on 30/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import XCTest

class FilterTest: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        
        app.launch()
    }
    
    func testTableViewSetDatasource() {
        let startVC = app.otherElements["BeerListViewController"]
        let collectionView = startVC.collectionViews["FiltersCollectionView"]
        XCTAssertTrue(collectionView.exists)
        
        let cell = collectionView.cells.matching(identifier: "FilterCollectionViewCell")
        
        let cellContent = cell.otherElements.matching(identifier: "FilterCellContent")
        var cellText = cellContent.staticTexts["M1"]
        XCTAssertTrue(cellText.exists)
        
        cellText = cellContent.staticTexts["M2"]
        XCTAssertTrue(cellText.exists)
        
        cellText = cellContent.staticTexts["M3"]
        XCTAssertTrue(cellText.exists)
    }
    
    func testApplyFirstFilter() {
        let startVC = app.otherElements["BeerListViewController"]
        let collectionView = startVC.collectionViews["FiltersCollectionView"]
        
        collectionView.cells.firstMatch.tap()
        
        XCTAssertEqual(startVC.tables["BeersTableView"].cells.count, 3)
    }
}
