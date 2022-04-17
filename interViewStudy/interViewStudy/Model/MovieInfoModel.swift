//
//  MovieInfo.swift
//  interViewStudy
//
//  Created by 김준건 on 2022/02/27.
//

import Foundation
import UIKit

struct MovieInfoModel: Hashable {
    let title: String
    let voteAverage: String
    let uuid: UUID
    let image: UIImage?
    
    static func == (lhs: MovieInfoModel, rhs: MovieInfoModel) -> Bool {
        lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
