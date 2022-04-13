//
//  NetworkModule.swift
//  interViewStudy
//
//  Created by 김준건 on 2022/02/15.
//

import Foundation

class NetworkModule: Networkable {
    private var dataTask: URLSessionDataTask?

    func runDataTask<T: Decodable>(request: URLRequest,
                                   completionHandler: @escaping (Result<T, Error>) -> Void) {
        
        dataTask?.cancel()
        dataTask = nil
        let rangeOfSuccessState = 200...299
        let customURLSession: URLSession = {
            let oneKilobyte = 1024
            let oneMegabyte = oneKilobyte * oneKilobyte
            URLCache.shared.memoryCapacity = 512 * oneMegabyte
            
            let config = URLSessionConfiguration.default
            config.requestCachePolicy = .returnCacheDataElseLoad
            
            return URLSession(configuration: config)
        }()

        dataTask = customURLSession.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
                return
            }
            guard let response = response as? HTTPURLResponse,
                  rangeOfSuccessState.contains(response.statusCode) else {
                DispatchQueue.main.async {
                    completionHandler(.failure(NetworkError.badResponse))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(.failure(NetworkError.invalidData))
                }
                return
            }
            
            do {
                let parsedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(.success(parsedData))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
            }
        }
        dataTask?.resume()
    }
}
