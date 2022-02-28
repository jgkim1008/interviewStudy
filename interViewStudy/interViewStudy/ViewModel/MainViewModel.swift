//
//  MainViewModel.swift
//  interViewStudy
//
//  Created by 김준건 on 2022/02/18.
//

import Foundation
import UIKit

enum viewState {
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
    var currentPage = 1
    var dataSource: DataSource?
    var viewState: viewState = .idle
    var movieList: [MovieInfoModel] = []
    
    func fetchData() {
        guard viewState == .idle else { return }
        let route = TMDBRoute.nowPlaying
        self.viewState = .isLoading
        
        networkManager.request(with: route,
                               queryItems: route.generateNowPlayingQueryItems(page: currentPage),
                               requestType: .request) { [weak self](result: Result<MovieModel, Error>) in
            switch result {
            case .success(let data):
                self?.currentPage += 1
                
                data.result.forEach { data in
                    guard let url = URL(string: "https://image.tmdb.org/t/p/w500/" + (data.posterPath ?? "")) else { return }
                    self?.imageManager.getImage(with: url) { result in
                        guard case .success(let imageData) = result else { return }
                        self?.movieList.append(MovieInfoModel(title: data.title, voteAverage: data.voteAverage.description, uuid: UUID(), image: imageData))
                        self?.viewState = .idle
                    }
                }
                var snapShot = SnapShot()
                if snapShot.sectionIdentifiers.isEmpty {
                    snapShot.appendSections([.main])
                }
                guard let movieList = self?.movieList else { return }
                snapShot.appendItems(movieList)
                self?.dataSource?.apply(snapShot, animatingDifferences: false)

            case .failure(let error):
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
  
}
