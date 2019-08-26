//
//  BeersTableViewTest.swift
//  spayUITests
//
//  Created by Pasini, Nicolò on 26/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

@testable import spay

import XCTest

class BeersTableViewTest: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        
        AssemblerWrapper.shared.register(assemblies: [TestNetworkAssembly()])
        
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func tableViewSetDatasource() {
        let startVC = app.otherElements["BeerListViewController"]
        let tableView = startVC.tables["BeersTableView"]
        XCTAssertTrue(tableView.exists)
//        XCTAssertTrue(tableView.cells.count == 25)
    }
}

