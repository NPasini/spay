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
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var filtersCollectionView: UICollectionView!
    
    private var filters: [Filter] = []
    private var viewModel: BeersViewModel?
    private var reloadDisposable: Disposable?
    private var scrollDisposable: Disposable?
    private var beerDetailsView: BeerDetailsView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OSLogger.uiLog(message: "Loaded", access: .public, type: .debug)
        
        viewModel = BeersViewModel()
        
        setFilters()
        configureUI()
        configureSearchBar()
        configureTableView()
        configureCollectionView()
    }
    
    override func didReceiveMemoryWarning() {
        if let disposable1 = reloadDisposable, !disposable1.isDisposed {
            disposable1.dispose()
        }
        
        if let disposable2 = scrollDisposable, !disposable2.isDisposed {
            disposable2.dispose()
        }
    }
    
    //MARK: Private Functions
    private func setFilters() {
        let f1 = Filter(value: "Munich")
        let f2 = Filter(value: "Fuggles")
        let f3 = Filter(value: "Cascade")
        let f4 = Filter(value: "Caramalt")
        let f5 = Filter(value: "Wheat Malt")
        let f6 = Filter(value: "First Gold")
        let f7 = Filter(value: "Dark Crystal")
        let f8 = Filter(value: "Maris Otter Extra Pale")
        
        filters = [f1, f2, f3 ,f4, f5, f6, f7, f8]
    }
    
    private func configureUI() {
        setTitle()
        offersView.layer.cornerRadius = 10
        
        beerDetailsView = UIView.Inflate(type: BeerDetailsView.self, owner: self, inside: detailsView)
        beerDetailsView?.delegate = self
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
        searchBar.delegate = self
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = UIColor(named: "BackGroundDarkBlue")
        
        tableView.rowHeight = 180
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        tableView.register(viewType: BeerTableViewCell.self)
        
        if let vm = viewModel {
            reloadDisposable = tableView.reactive.reloadData <~ vm.beersDataSource.signal.map({_ in
                OSLogger.uiLog(message: "Reloading TableView", access: .public, type: .debug)
                return })
            
//            scrollDisposable = vm.scrollToTopPipe.output.signal.observe(on: UIScheduler()).observeValues { () in
//                DispatchQueue.main.async {
//                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
//                }
//            }
        }
    }
    
    private func configureCollectionView() {
        filtersCollectionView.delegate = self
        filtersCollectionView.dataSource = self
        
        filtersCollectionView.indicatorStyle = .white
        
        if let flowLayout = filtersCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 150, height: 45)
        }
        
        filtersCollectionView.register(viewType: FilterCollectionViewCell.self)
    }
    
    private func isLoadingCell(at indexPath: IndexPath) -> Bool {
        if let currentCount = viewModel?.beersDataSource.value.count {
            return indexPath.row >= (currentCount - 1)
        } else {
            return false
        }
    }
    
    private func deselectFilters() {
        for filter: Filter in filters {
            if (filter.selected) {
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
            deselectFilters()
            searchBar.text = ""
            
            cell.tapOnFilter()
            
            if let filter = cell.filter {
                viewModel?.addFilter(filter)
            }
        }
    }
}

extension BeersListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        deselectFilters()
        viewModel?.getBeersBy(beerName: searchText.trimmingCharacters(in: .newlines))
    }
}

extension BeersListViewController: BeerCellDelegate {
    func showMoreDetails(for model: Beer) {
        detailsView.isHidden = false
        beerDetailsView?.showDetails(for: model)
    }
}

extension BeersListViewController: BeerDetailsViewDelegate {
    func closeDetailsView() {
        detailsView.isHidden = true
    }
}
