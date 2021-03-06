//
//  TMDBRoute.swift
//  interViewStudy
//
//  Created by 김준건 on 2022/02/17.
//

import Foundation

enum TMDBRoute: Route {
    case nowPlaying
    case getImage
    case search
    
    var scheme: String {
        return "https"
    }
    
    var baseURL: String {
        return "//api.themoviedb.org"
    }
    
    var path: String {
        switch self {
        case .nowPlaying:
            return "/3/movie/now_playing"
        case .getImage:
            return "image.tmdb.org/t/p/w500/"
        case .search:
            return "/3/search/movie"
        }
    }
    
    func generateNowPlayingQueryItems(page: Int = 1) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "api_key",value:"6a57b97030d7523e4a313c9dbd106cdd"))
        queryItems.append(URLQueryItem(name: "language", value: "en-US"))
        queryItems.append(URLQueryItem(name: "page", value: page.description))
        return queryItems
    }
    
    func generateSearchQueryItems(query: String?) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        queryItems.append(URLQueryItem(name: "query", value: query))
        queryItems.append(URLQueryItem(name: "api_key",value:"6a57b97030d7523e4a313c9dbd106cdd"))
        return queryItems
    }
}
