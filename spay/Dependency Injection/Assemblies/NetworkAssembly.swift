//
//  NetworkAssembly.swift
//  spay
//
//  Created by Pasini, Nicolò on 20/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Swinject
import Foundation

class NetworkAssembly: Assembly {
    func assemble(container: Container) {
        container.register(NetworkService.self) { _ in return APIPerformer() }.inObjectScope(.container)
    }
}
