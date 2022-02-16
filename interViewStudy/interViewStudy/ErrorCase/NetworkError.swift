//
//  NetworkError.swift
//  interViewStudy
//
//  Created by 김준건 on 2022/02/15.
//

import Foundation

enum NetworkError: LocalizedError {
    case badResponse
    case invalidData
    case invalidURL
    
    var errorDescription: String? {
        switch self {
        case .badResponse:
            return "유효한 HTTP 응답이 아닙니다"
        case .invalidData:
            return "유효한 데이터가 아닙니다"
        case .invalidURL:
            return "유효한 URL이 아닙니다"
        }
    }
}
