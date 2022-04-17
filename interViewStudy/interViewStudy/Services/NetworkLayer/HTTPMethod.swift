//
//  HTTPMethod.swift
//  interViewStudy
//
//  Created by 김준건 on 2022/02/15.
//

import Foundation

enum HTTPMethod: String {
    case get
    case put
    case petch
    case delete
    case post
    
    var type: String {
        return self.rawValue.uppercased()
    }
}
