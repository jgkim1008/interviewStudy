//
//  Networkable.swift
//  interViewStudy
//
//  Created by 김준건 on 2022/02/15.
//

import Foundation

protocol Networkable {
    mutating func runDataTask<T: Decodable>(request: URLRequest, completionHandler: @escaping (Result<T,Error>) -> Void)
}
