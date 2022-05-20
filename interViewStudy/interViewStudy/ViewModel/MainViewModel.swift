//
//  MainViewModel.swift
//  interViewStudy
//
//  Created by 김준건 on 2022/02/18.
//

import Foundation
import UIKit

enum ViewState {
    case idle
    case isLoading
}

enum Section {
    case main
}
typealias DataSource = UICollectionViewDiffableDataSource<Section, MovieInfoModel>
typealias SnapShot = NSDiffableDataSourceSnapshot<Section, MovieInfoModel>

final class MainViewModel {
    private let networkManager = NetworkManager(networkable: NetworkModule())
    private let imageManager = ImageManager()
    private var page = (currentPage: 1, maximumPage: Int.max)
    private var viewState: ViewState = .idle
    var dataSource: DataSource?

    private var movieList: [MovieInfoModel] = [] {
        didSet {
            guard var snapShot = dataSource?.snapshot() else { return }
            if snapShot.sectionIdentifiers.isEmpty {
                snapShot.appendSections([.main])
            }
            snapShot.appendItems(movieList)
            dataSource?.apply(snapShot, animatingDifferences: false)
        }
    }
    
    func fetchData() {
        guard viewState == .idle else { return }
        let route = TMDBRoute.nowPlaying
        self.viewState = .isLoading
        
        networkManager.request(with: route,
                               queryItems: route.generateNowPlayingQueryItems(page: page.currentPage),
                               requestType: .request) { [weak self] (result: Result<MovieModel, Error>) in
            switch result {
            case .success(let data):
                guard self?.isReachTheEnd(data) == false else {
                    return 
                }
                
                data.result.forEach { data in
                    guard let url = URL(string: "https://image.tmdb.org/t/p/w500/" + (data.posterPath ?? "")) else { return }
                    self?.imageManager.getImage(with: url) { result in
                        guard case .success(let imageData) = result else { return }
                        self?.movieList.append(MovieInfoModel(title: data.title, voteAverage: data.voteAverage.description, uuid: UUID(), image: imageData))
                        self?.viewState = .idle
                    }
                }
            case .failure(let error):
                if error.localizedDescription != "cancelled" {
                    assertionFailure(error.localizedDescription)
                }
            }
        }
    }
    
    func isReachTheEnd(_ data: MovieModel) -> Bool {
        guard page.currentPage < page.maximumPage else {
            return true
        }
        page.maximumPage = data.totalPages
        page.currentPage += 1
        
        return false
    }
}
