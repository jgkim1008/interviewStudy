//
//  TMDBRoute.swift
//  interViewStudy
//
//  Created by 김준건 on 2022/02/17.
//

import Foundation

enum TMDBRoute: Route {
    case nowPlaying
    
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
        }
    }
}
//https://api.themoviedb.org/3/movie/now_playing?api_key=<<api_key>>&language=en-US&page=1
