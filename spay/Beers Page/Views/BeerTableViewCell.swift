//
//  BeerTableViewCell.swift
//  spay
//
//  Created by Pasini, Nicolò on 21/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import UIKit
import SDWebImage

class BeerTableViewCell: UITableViewCell, Identifiable {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var tagline: UILabel!
    @IBOutlet weak var beerImage: UIImageView!
    @IBOutlet weak var beerDescription: UILabel!
    
    weak var delegate: BeerCellDelegate?
    
    private var beerModel: Beer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        name.text = ""
        tagline.text = ""
        beerDescription.text = ""
        beerImage.image = UIImage()
    }
    
    func configure(with model: Beer) {
        beerModel = model
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
    
    @IBAction func showMore() {
        if let model = beerModel {
            delegate?.showMoreDetails(for: model)
        }
    }
}
