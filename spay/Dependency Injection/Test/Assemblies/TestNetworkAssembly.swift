//
//  TestNetworkAssembly.swift
//  spayUITests
//
//  Created by Pasini, Nicolò on 26/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Swinject
import Foundation

class TestNetworkAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NetworkService.self) { _ in return TestNetworkComponent() }.inObjectScope(.container)
    }
}
