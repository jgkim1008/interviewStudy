//
//  Route.swift
//  interViewStudy
//
//  Created by 김준건 on 2022/02/15.
//

import Foundation

protocol Route {
    var scheme: String { get }
    var baseURL: String { get }
    var path: String { get }
}
