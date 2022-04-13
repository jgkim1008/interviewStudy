//
//  ImageModule.swift
//  interViewStudy
//
//  Created by 김준건 on 2022/02/27.
//

import Foundation
import UIKit

typealias ImageCompletion = (URL, UIImage?) -> Void

class ImageManager {
    let networkManager = NetworkManager(networkable: NetworkModule())
    private let cache = NSCache<NSURL, UIImage>()
    private var completions: [NSURL: [ImageCompletion]]? = [:]
    private let rangeOfSuccessState = 200...299
    
    func getImage(with url: URL,
                            completionHandler: @escaping (Result<UIImage, Error>) -> Void) {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            completionHandler(.success(cachedImage))
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completionHandler(.failure(error))
                }
                return
            }
            guard let response = response as? HTTPURLResponse,
            ((self?.rangeOfSuccessState.contains(response.statusCode)) != nil) else {
                DispatchQueue.main.async {
                    completionHandler(.failure(NetworkError.badResponse))
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completionHandler(.failure(NetworkError.invalidData))
                }
                return
            }
            
            DispatchQueue.main.async {
                self?.cache.setObject(image, forKey: url as NSURL)
                completionHandler(.success(image))
            }
            
      }.resume()
    }
}

