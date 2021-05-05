//
//  PhotoStore.swift
//  Photorama
//
//  Created by Chao Mei on 27/4/21.
//

import Foundation

class PhotoStore {
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    private func processPhotosRequest (data: Data?, error: Error?) ->
    Result<[Photo], Error> {
        guard let jsonData = data else {
            return .failure(error!)
        }
        return FlickrAPI.photos(fromJSON: jsonData)
    }
    
    func fetchInterestingPhotos (completion: @escaping (Result<[Photo], Error>) -> Void) {
        let url = FlickrAPI.interestingPhotoURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
        /*if let jsonData = data {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            }
            } else if let requestError = error {
                print("Error fetching interest photos: \(requestError)")
            } else {
                print("Unexpect error with the request")
            }*/
            let result = self.processPhotosRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
}
