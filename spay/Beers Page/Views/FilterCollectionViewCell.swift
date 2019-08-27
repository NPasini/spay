//
//  FilterCollectionViewCell.swift
//  spay
//
//  Created by Pasini, Nicolò on 27/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell, Identifiable {
    
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var filterLabel: UILabel!
    
    var filter: Filter?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        filterLabel.textColor = UIColor.white
        content.backgroundColor = UIColor(named: "BackgroundGrey")
    }
    
    //MARK: Public Functions
    func configure(with filter: Filter) {
        self.filter = filter
        content.layer.cornerRadius = 20
        filterLabel.text = filter.filterValue
        
        setUI(for: filter.selected)
    }
    
    func tapOnFilter() {
        if let filterModel = filter {
            filterModel.changeSelection()
            setUI(for: filterModel.selected)
        }
    }
    
    //MARK: Private Functions
    private func setUI(for selected: Bool) {
        if (selected) {
            filterLabel.textColor = UIColor.black
            content.backgroundColor = UIColor(named: "BackGroundOrange")
        } else {
            filterLabel.textColor = UIColor.white
            content.backgroundColor = UIColor(named: "BackgroundGrey")
        }
    }
}
