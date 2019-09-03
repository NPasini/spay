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
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    
    private var filters: [Filter] = []
    private var viewModel: BeersViewModel?
    private var beerDetailsView: BeerDetailsView?
    private var compositeDisposable = CompositeDisposable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OSLogger.uiLog(message: "Loaded", access: .public, type: .debug)
        
        viewModel = BeersViewModel()
        
        setFilters()
        configureUI()
        configureSearchBar()
        configureTableView()
        configureCollectionView()
        
        viewModel?.getBeers()
    }
    
    deinit {
        if (!compositeDisposable.isDisposed) {
            compositeDisposable.dispose()
        }
    }
    
    //MARK: Private Functions
    private func setFilters() {
        filters = viewModel?.getFilters() ?? []
    }
    
    private func configureUI() {
        setTitle()
        offersView.layer.cornerRadius = 10
        
        beerDetailsView = UIView.Inflate(type: BeerDetailsView.self, owner: self, inside: detailsView)
        beerDetailsView?.delegate = self
    }
    
    private func setTitle() {
        let fullTitle = NSMutableAttributedString(attributedString: NSAttributedString(string: "Beer", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .light), NSAttributedString.Key.foregroundColor: UIColor.white]))
        fullTitle.append(NSAttributedString(string: " Box", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.white]))
        
        let titleLabel = UILabel()
        titleLabel.attributedText = fullTitle
        self.navigationItem.titleView = titleLabel
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
        compositeDisposable += searchBar.reactive.continuousTextValues.throttle(0.5, on: QueueScheduler.init(qos: .background, name: "BeersViewModel.background.queue")).observeValues { [weak self] (text: String?) in
            if let searchText = text {
                self?.viewModel?.getBeersByNameSearch(searchText)
            }
        }
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        let spinnerView: UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60))
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        spinnerView.startAnimating()
        footerView.addSubview(spinnerView)
        NSLayoutConstraint.activate([
            spinnerView.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
            ])
        
        tableView.rowHeight = 180
        tableView.tableFooterView = footerView
        tableView.register(viewType: BeerTableViewCell.self)
        tableView.backgroundColor = UIColor(named: "BackGroundDarkBlue")
        
        if let vm = viewModel {
            compositeDisposable += tableView.reactive.reloadData <~ vm.beersDataSource.signal.map({_ in
                OSLogger.uiLog(message: "Reloading TableView", access: .public, type: .debug)
                return })
            
            compositeDisposable += spinnerView.reactive.isAnimating <~ vm.stopFetching.producer.map({ [weak self] (stopFetching: Bool) -> Bool in
                DispatchQueue.main.async {
                    if (stopFetching) {
                        self?.tableView.tableFooterView = UIView(frame: .zero)
                    } else {
                        self?.tableView.tableFooterView = footerView
                    }
                }
                
                return !stopFetching
            })
        }
    }
    
    private func configureCollectionView() {
        filtersCollectionView.delegate = self
        filtersCollectionView.dataSource = self
        filtersCollectionView.indicatorStyle = .white
        filtersCollectionView.register(viewType: FilterCollectionViewCell.self)
        
        if let flowLayout = filtersCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 150, height: 45)
        }
    }
    
    private func isLoadingCell(at indexPath: IndexPath) -> Bool {
        if let currentCount = viewModel?.beersDataSource.value.count {
            return indexPath.row >= (currentCount - 1)
        } else {
            return false
        }
    }
    
    private func deselectOtherFilters(than selectedFilter: Filter?) {
        for filter: Filter in filters {
            if (filter != selectedFilter && filter.selected) {
                if let index = filters.firstIndex(of: filter), let selectedCell = filtersCollectionView.cellForItem(at: IndexPath(row: index, section: 0)) as? FilterCollectionViewCell {
                    selectedCell.tapOnFilter()
                } else {
                    filter.changeSelection()
                }
            }
        }
    }
}

extension BeersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.beersDataSource.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cellModel = viewModel?.beersDataSource.value[indexPath.row], let cell = tableView.dequeueReusableCell(withIdentifier: BeerTableViewCell.identifier, for: indexPath) as? BeerTableViewCell {
            cell.delegate = self
            cell.configure(with: cellModel)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension BeersListViewController: UITableViewDelegate {
}

extension BeersListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if (indexPaths.contains(where: isLoadingCell(at:))) {
            OSLogger.uiLog(message: "Fetching new Data Models", access: .public, type: .debug)
            viewModel?.getBeers()
        }
    }
}

extension BeersListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as? FilterCollectionViewCell {
            cell.configure(with: filters[indexPath.row])
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension BeersListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 150
        let height: CGFloat = 45
        
        if let collectionView = Bundle.main.getView(from: FilterCollectionViewCell.self, owner: nil) {
            collectionView.configure(with: filters[indexPath.row])
            width = collectionView.filterLabel.intrinsicContentSize.width + 30
        }
        
        return CGSize(width: width, height: height)
    }
}

extension BeersListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell {
            if let filter = cell.filter {                
                deselectOtherFilters(than: filter)
                cell.tapOnFilter()
                
                if (filter.selected) {
                    viewModel?.getBeersWithFilter(filter)
                } else {
                    viewModel?.getBeersWithFilter(nil)
                }
            }
        }
    }
}

extension BeersListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension BeersListViewController: BeerCellDelegate {
    func showMoreDetails(for model: Beer) {
        detailsView.isHidden = false
        beerDetailsView?.showDetails(for: model)
        searchBar.isUserInteractionEnabled = false
    }
}

extension BeersListViewController: BeerDetailsViewDelegate {
    func closeDetailsView() {
        detailsView.isHidden = true
        searchBar.isUserInteractionEnabled = true
    }
}
