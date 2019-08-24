//
//  BookmarkView.swift
//  spay
//
//  Created by Pasini, Nicolò on 24/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import UIKit

@IBDesignable
class BookmarkView: UIView {
    
    @IBInspectable var bookmarkWidth: CGFloat = 25
    @IBInspectable var bookmarkHeight: CGFloat = 35
    @IBInspectable var bookmarkColor: UIColor = UIColor(named: "BackgroundGrey") ?? UIColor.white
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
//            context.setFillColor(bookmarkColor.cgColor)
//            context.fill(rect)
            
//            let drawSize = CGSize(width: bookmarkWidth, height: bookmarkHeight)
            let trianglePath = UIBezierPath()
            trianglePath.move(to: CGPoint(x: 0, y: bookmarkHeight))
            trianglePath.addLine(to: CGPoint(x: bookmarkWidth/2, y: bookmarkHeight - 10))
            trianglePath.addLine(to: CGPoint(x: bookmarkWidth, y: bookmarkHeight))
            bookmarkColor.setFill()
            trianglePath.fill()
        }
    }
}
