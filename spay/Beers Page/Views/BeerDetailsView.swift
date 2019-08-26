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
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var bookmarkView: UIView!
    @IBOutlet weak var beerImage: UIImageView!
    @IBOutlet weak var beerDescription: UILabel!
    @IBOutlet weak var beerImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var beerImageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var beerImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailsViewHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: BeerDetailsViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collapseHeight()
        
        detailsView.layer.cornerRadius = 10
        detailsView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        let _ = UIView.Inflate(type: BookmarkView.self, owner: self, inside: bookmarkView)
    }
    
    func showDetails(for model: Beer) {
        name.text = model.name
        tagline.text = model.tagline
        beerDescription.text = model.description
        
        if let imageURL = URL(string: model.imageUrl) {
            beerImage.sd_setImage(with: imageURL) { [weak self] (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
                guard error == nil else { return }
                
                self?.beerImage.image = image
            }
        } else {
            beerImage.image = UIImage()
        }
        
        show()
    }
    
    private func collapseHeight() {
        beerImageTopConstraint.constant = 0
        beerImageBottomConstraint.constant = 0
        beerImageHeightConstraint.constant = 0
        detailsViewHeightConstraint.constant = 0
    }
    
    private func expandHeight() {
        beerImageTopConstraint.constant = 40
        beerImageBottomConstraint.constant = 20
        beerImageHeightConstraint.constant = 225
        detailsViewHeightConstraint.constant = 285
    }
    
    private func show() {
        UIView.animate(withDuration: 0.3, animations: {
            self.expandHeight()
            self.layoutIfNeeded()
        })
    }
    
    @IBAction func close() {
        UIView.animate(withDuration: 0.3, delay: 0, animations: {
            self.collapseHeight()
            self.layoutIfNeeded()
        }) { (completed: Bool) in
            if (completed) {
                self.delegate?.closeDetailsView()
            }
        }
    }
}
