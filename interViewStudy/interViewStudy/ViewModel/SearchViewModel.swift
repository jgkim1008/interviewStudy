//
//  SearchViewModel.swift
//  interViewStudy
//
//  Created by 김준건 on 2022/02/28.
//

import Foundation
import UIKit

typealias SearchViewDataSource = UICollectionViewDiffableDataSource<Section, MovieInfoModel>
typealias SearchViewSnapShot = NSDiffableDataSourceSnapshot<Section, MovieInfoModel>

final class SearchViewModel {
    private let networkManager = NetworkManager(networkable: NetworkModule())
    private let imageManager = ImageManager()
    private var workItem: DispatchWorkItem?
    private var searchResultList: [MovieInfoModel] = []
    var dataSource: SearchViewDataSource?

    
    func removeSnapShot() {
        var snapShot = dataSource?.snapshot()
        snapShot?.deleteAllItems()
    }
    
    func makeSnapShot(data: [MovieInfoModel]) {
        var snapshot = SearchViewSnapShot()
        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections([.main])
        }
        snapshot.appendItems(data, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func debounce(action: @escaping () -> Void) {
        workItem?.cancel()
        workItem = DispatchWorkItem(block: action)
        guard let validWorkItem = workItem else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: validWorkItem)
    }
    
    func searchQuery(text: String?) {
        let route = TMDBRoute.search
        let filteredText = filter(text)
        if filteredText == "" {
            return
        }
        debounce { [weak self] in
            self?.searchResultList = []
            self?.networkManager.request(with: route, queryItems: route.generateSearchQueryItems(query: filteredText),requestType: .request) { (result: Result<SearchModel, Error>) in
                switch result {
                case .success(let data):
                    self?.makeMovieInfoModel(with: data)
                    
                case .failure(let error):
                    if error.localizedDescription != "cancelled" {
                        assertionFailure(error.localizedDescription)
                    }
                }
                
            }
        }
    }
    
    private func makeMovieInfoModel(with data: SearchModel) {
        let group = DispatchGroup()
        data.results.forEach { movie in
            guard let url = URL(string: "https://image.tmdb.org/t/p/w500/" + (movie.posterPath ?? "")) else { return }
            group.enter()
            imageManager.getImage(with: url) { [weak self] result in
                guard case .success(let poster) = result else { return }
                self?.searchResultList.append(MovieInfoModel(title: movie.title, voteAverage: movie.voteAverage.description, uuid: UUID(), image: poster))
                group.leave()
            }
        }
        
        group.notify(queue: .global(qos: .userInteractive)) {
            self.makeSnapShot(data: self.searchResultList)
        }
    }
    
    private func filter(_ text: String?) -> String? {
        guard let text = text else {
            return nil
        }
        
        return text.replacingOccurrences(of: " ", with: "")
    }
}

