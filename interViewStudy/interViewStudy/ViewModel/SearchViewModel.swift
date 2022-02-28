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
    var dataSource: SearchViewDataSource?
    var workItem: DispatchWorkItem?
    var searchResultList: [MovieInfoModel] = []
    {
        willSet(newValue) {
            makeSnapShot(data: newValue)
        }
    }
    
    func removeSnapShot() {
        var snapShot = dataSource?.snapshot()
        snapShot?.deleteAllItems()
    }
    
    func makeSnapShot(data: [MovieInfoModel]) {
        var snapshot = SearchViewSnapShot()
        snapshot.appendSections([.main])
        snapshot.appendItems(data)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    func debounce(action: @escaping () -> Void) {
            workItem?.cancel()
            workItem = DispatchWorkItem(block: action)
            guard let validWorkItem = workItem else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: validWorkItem)
        }
    
    func searchQuery(text: String?) {
        let route = TMDBRoute.search
        let filteredText = filter(text)
        if filteredText == nil {
            return
        }
        debounce { [weak self] in
            self?.networkManager.request(with: route, queryItems: route.generateSearchQueryItems(query: filteredText),
                                   requestType: .request) { (result: Result<SearchModel, Error>) in
                switch result {
                case .success(let data):
                    data.results.forEach { data in
                        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/" + (data.posterPath ?? "")) else { return }
                        self?.imageManager.getImage(with: url) { result in
                            guard case .success(let imageData) = result else { return }
                            self?.searchResultList.append(MovieInfoModel(title: data.title, voteAverage: data.voteAverage.description, uuid: UUID(), image: imageData))

                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func filter(_ text: String?) -> String? {
        guard let text = text else {
            return nil
        }

        return text.replacingOccurrences(of: " ", with: "")
    }
}

