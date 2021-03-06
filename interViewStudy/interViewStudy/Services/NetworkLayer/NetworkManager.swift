//
//  NotworkManager.swift
//  interViewStudy
//
//  Created by 김준건 on 2022/02/15.
//
import UIKit
import Foundation

class NetworkManager {
    private var networkable: Networkable
    
    init(networkable: Networkable = NetworkModule()) {
        self.networkable = networkable
    }
    
    func request<T: Decodable>(with route: Route,
                               queryItems: [URLQueryItem]? = nil,
                               header: [String: String]? = nil,
                               bodyParameters: [String: Any]? = nil,
                               httpMethod: HTTPMethod = .get,
                               requestType: URLRequestBuilder,
                               completionHandler: @escaping (Result<T, Error>) -> Void)
    {
        
        guard let urlRequest = requestType.buildRequest(route: route,
                                                        queryItems: queryItems,
                                                        header: header,
                                                        bodyParameters: bodyParameters,
                                                        httpMethod: httpMethod)
        else {
            completionHandler(.failure(NetworkError.invalidURL))
            return
        }
        networkable.runDataTask(request: urlRequest, completionHandler: completionHandler)
    }
}
