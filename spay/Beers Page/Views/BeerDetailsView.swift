//
//  BeerDetailsView.swift
//  spay
//
//  Created by Pasini, Nicolò on 24/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import UIKit
import SDWebImage

class BeerDetailsView: UIView {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tagline: UILabel!
    @IBOutlet weak var bookmarkView: UIView!
    @IBOutlet weak var beerImage: UIImageView!
    @IBOutlet weak var beerDescription: UILabel!
    
    func configure(with model: Beer) {
        name.text = model.name
        tagline.text = model.tagline
        beerDescription.text = model.description
        
        if let imageURL = URL(string: model.image_url) {
            beerImage.sd_setImage(with: imageURL) { [weak self] (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
                guard error == nil else { return }
                
                self?.beerImage.image = image
            }
        } else {
            beerImage.image = UIImage()
        }
    }
}
