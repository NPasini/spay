//
//  BeersListViewController.swift
//  spay
//
//  Created by Pasini, Nicolò on 18/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import UIKit

class BeersListViewController: UIViewController {
    
    @IBOutlet weak var offersView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle()
        configureSearchBar()
        configureTableView()
        offersView.layer.cornerRadius = 10
    }
    
    private func setTitle() {
        let fullTitle = NSMutableAttributedString(string: "")
        let title = NSAttributedString(string: "Beer", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .light), NSAttributedString.Key.foregroundColor: UIColor.white])
        let boldTitle = NSAttributedString(string: " Box", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.white])
        fullTitle.append(title)
        fullTitle.append(boldTitle)
        titleLabel.attributedText = fullTitle
    }
    
    private func configureSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.barStyle = .black
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.obscuresBackgroundDuringPresentation = false
        
        self.navigationItem.searchController = searchController
    }
    
    private func configureTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = UIColor(named: "BackGroundDarkBlue")
        
        let nib = UINib(nibName: "BeerTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "BeerTableViewCell")
    }
}

extension BeersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension BeersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension BeersListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

