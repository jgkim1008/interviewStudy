//
//  Movie.swift
//  interViewStudy
//
//  Created by 김준건 on 2022/02/15.
//

import Foundation

struct Movie: Decodable {
    let dates: MovieDate
    let page: Int, totalPages: Int, totalResults: Int
    let result: MovieResult
    
    struct MovieDate: Decodable {
        let maximum: String
        let minimum: String
    }
    
    struct MovieResult: Decodable {
        let adult: Bool
         let backdropPath: String
         let genreIDS: [Int]
         let id: Int
         let originalLanguage: String
         let originalTitle, overview: String
         let popularity: Double
         let posterPath, releaseDate, title: String
         let video: Bool
         let voteAverage: Double
         let voteCount: Int

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
}
