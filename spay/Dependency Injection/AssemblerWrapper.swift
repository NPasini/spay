//
//  AssemblerWrapper.swift
//  spay
//
//  Created by Pasini, Nicolò on 20/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import Swinject
import Foundation

class AssemblerWrapper {
    var innerAssembler: Assembler = Assembler()
    static let shared: AssemblerWrapper = AssemblerWrapper()
    
    private init() { }
    
    func register(assemblies: [Assembly]) {
        self.innerAssembler = Assembler(assemblies)
    }
    
    func resolve<Service>(_ service: Service.Type) -> Service? {
        if let container = self.innerAssembler.resolver as? Container {
            let threadSafeContainer: Resolver = container.synchronize()
            return threadSafeContainer.resolve(Service.self)
        } else {
            return nil
        }
    }
}
