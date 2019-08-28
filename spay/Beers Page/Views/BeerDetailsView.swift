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
    @IBOutlet weak var hopsLabel: UILabel!
    @IBOutlet weak var maltsLabel: UILabel!
    @IBOutlet weak var yeastLabel: UILabel!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var bookmarkView: UIView!
    @IBOutlet weak var beerImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var beerDescription: UILabel!
    @IBOutlet weak var hopsTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var maltsTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var yeatsTopConstraint: NSLayoutConstraint!
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
    
    //MARK: Public Functions
    func showDetails(for model: Beer) {
        name.text = model.name
        tagline.text = model.tagline
        beerDescription.text = model.description
        
        if let urlString = model.imageUrl, let imageURL = URL(string: urlString) {
            beerImage.sd_setImage(with: imageURL) { [weak self] (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) in
                guard error == nil else { return }
                
                self?.beerImage.image = image
            }
        } else {
            beerImage.image = UIImage()
        }
        
        insertMalts(model.malts)
        insertHops(model.hops)
        insertYeast(model.yeast)
        
        show()
    }
    
    //MARK: Private Functions
    private func insertMalts(_ malts: [Malt]) {
        if (malts.count > 0) {
            let maltsString = NSMutableAttributedString(attributedString: NSAttributedString(string: "Malts", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.white]))
            
            let maltsInfo: String = malts.reduce("") { (text: String, malt: Malt) -> String in
                return text + "\n\(malt.name) \(malt.amount.value) \(malt.amount.unit)"
            }
            
            maltsString.append(NSAttributedString(string: maltsInfo, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .light), NSAttributedString.Key.foregroundColor: UIColor.white]))
            
            maltsLabel.attributedText = maltsString
            maltsTopConstraint.constant = 15
        } else {
            maltsLabel.text = ""
            maltsTopConstraint.constant = 0
        }
    }
    
    private func insertHops(_ hops: [Hop]) {
        if (hops.count > 0) {
            let hopsString = NSMutableAttributedString(attributedString: NSAttributedString(string: "Hops", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.white]))
            
            let hopsInfo: String = hops.reduce("") { (text: String, hop: Hop) -> String in
                return text + "\n\(hop.name) \(hop.amount.value) \(hop.amount.unit)"
            }
            
            hopsString.append(NSAttributedString(string: hopsInfo, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .light), NSAttributedString.Key.foregroundColor: UIColor.white]))
            
            hopsLabel.attributedText = hopsString
            hopsTopConstraint.constant = 15
        } else {
            hopsLabel.text = ""
            hopsTopConstraint.constant = 0
        }
    }
    
    private func insertYeast(_ yeast: String?) {
        if let yeastString = yeast, yeastString.count > 0 {
            let yeastMutableString = NSMutableAttributedString(attributedString: NSAttributedString(string: "Yeast", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.white]))
            
            let yeastInfo = NSAttributedString(string: "\n" + yeastString, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .light), NSAttributedString.Key.foregroundColor: UIColor.white])
            
            yeastMutableString.append(yeastInfo)
            
            yeastLabel.attributedText = yeastMutableString
            yeatsTopConstraint.constant = 15
        } else {
            yeastLabel.text = ""
            yeatsTopConstraint.constant = 0
        }
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
        self.scrollView.setContentOffset(CGPoint(x: 0, y: -self.scrollView.contentInset.top), animated: false)
        
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
