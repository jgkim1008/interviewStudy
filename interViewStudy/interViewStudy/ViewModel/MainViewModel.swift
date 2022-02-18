//
//  MainViewModel.swift
//  interViewStudy
//
//  Created by 김준건 on 2022/02/18.
//

import Foundation

class MainViewModel {
    private let networkManager = NetworkManager(networkable: NetworkModule())
    private var movieData: [Movie] = [] {
        didSet {
            NotificationCenter.default.post(name: .dataReceiveNotifiaction, object: nil)
        }
    }
    
    init() {
        fetchData(pageNum: "1")
    }
    
    func fetchData(pageNum: String) {
        let route = TMDBRoute.nowPlaying
        networkManager.request(with: route,
                               queryItems: route.generateNowPlayingQueryItems(apiKey: "1"),
                               requestType: .request) { [weak self](result: Result<Movie, Error>) in
            switch result {
            case .success(let data):
                self?.movieData.append(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
