//
//  RepositoriesAssembly.swift
//  spay
//
//  Created by Pasini, Nicolò on 02/09/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Foundation

import Swinject
import Foundation

class RepositoriesAssembly: Assembly {
    func assemble(container: Container) {
        container.register(BeersRepositoryService.self) { _ in return BeerRepository() }
    }
}
