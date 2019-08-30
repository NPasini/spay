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
        XCTAssertEqual(collectionView.cells.count, 5)
        
        let firstCellContent = collectionView.cells.matching(identifier: "FilterCollectionViewCell").otherElements.matching(identifier: "FilterCellContent")
        let firstCellText = firstCellContent.staticTexts["Munich"]
//        XCTAssertTrue(firstCell.exists)
//        firstCell.tap()
    }
}
