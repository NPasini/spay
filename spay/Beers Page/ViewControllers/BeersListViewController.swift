//
//  BeersListViewController.swift
//  spay
//
//  Created by Pasini, Nicolò on 18/08/2019.
//  Copyright © 2019 Pasini, Nicolò. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

class BeersListViewController: UIViewController {
    
    @IBOutlet weak var offersView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var disposable: Disposable?
    var viewModel: BeersViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = BeersViewModel()
        
        setTitle()
        configureSearchBar()
        configureTableView()
        offersView.layer.cornerRadius = 10
    }
    
    override func didReceiveMemoryWarning() {
        if let d = disposable, !d.isDisposed {
            d.dispose()
        }
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
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = UIColor(named: "BackGroundDarkBlue")
        
        tableView.rowHeight = 180
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        let nib = UINib(nibName: "BeerTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "BeerTableViewCell")
        
        if let vm = viewModel {
            disposable = tableView.reactive.reloadData <~ vm.beersModelsList.signal.map({_ in return ()})
        }
    }
}

extension BeersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.beersModelsList.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cellModel = viewModel?.beersModelsList.value[indexPath.row], let cell = tableView.dequeueReusableCell(withIdentifier: "BeerTableViewCell", for: indexPath) as? BeerTableViewCell {
            cell.configure(with: cellModel)
            return cell
        } else {
            return UITableViewCell()
            
        }
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

