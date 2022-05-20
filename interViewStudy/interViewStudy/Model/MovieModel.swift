//
//  Movie.swift
//  interViewStudy
//
//  Created by 김준건 on 2022/02/15.
//

import Foundation
import UIKit

struct MovieModel: Decodable, Hashable {
    let dates: MovieDate
    let result: [MovieData]
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case dates
        case result = "results"
        case totalPages = "total_pages"
    }
    
    struct MovieDate: Decodable {
        let maximum: String
        let minimum: String
    }
    
    static func == (lhs: MovieModel, rhs: MovieModel) -> Bool {
        lhs.result.map { $0.id } == rhs.result.map {$0.id}
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(result.map{$0.id})
    }
    
}

struct MovieData: Decodable, Hashable {
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle, overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    
    static func == (lhs: MovieData, rhs: MovieData) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}
