//
//  ReactiveExtensions.swift
//  spay
//
//  Created by Pasini, Nicolò on 02/09/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import UIKit
import ReactiveSwift

extension Reactive where Base: UIActivityIndicatorView {
    /// Sets whether the activity indicator should be animating.
    public var isAnimating: BindingTarget<Bool> {
        return makeBindingTarget { $1 ? $0.startAnimating() : $0.stopAnimating() }
    }
}
