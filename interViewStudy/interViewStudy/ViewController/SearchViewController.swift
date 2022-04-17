//
//  SearchViewController.swift
//  interViewStudy
//
//  Created by 김준건 on 2022/02/28.
//

import UIKit

final class SearchViewController: UIViewController {
    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .tableLayout)
        collectionView.register(SearchTableViewCell.self, forCellWithReuseIdentifier: SearchTableViewCell.identifier)
        return collectionView
    }()
    private var viewModel = SearchViewModel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigationItem()
        view.backgroundColor = .black
        setLayoutForTableView()
        setupSearchController()
        makeDataSource()

    }
    
    private func makeNavigationItem() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.topItem?.title = "검색"
        navigationController?.navigationBar.tintColor = .white
    }
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.searchResultsUpdater = self
        searchController.searchBar.backgroundColor = .black
        searchController.searchBar.searchTextField.tintColor = .systemGray6
        searchController.searchBar.barStyle = .black
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setLayoutForTableView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                                     collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                     collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
    
    
    private func makeDataSource() {
        viewModel.dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, movieData) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell
            cell?.configure(of: movieData)
        
            return cell
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text
        viewModel.searchQuery(text: text)
    }
}


