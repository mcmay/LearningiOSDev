//
//  PhotoStore.swift
//  Photorama
//
//  Created by Chao Mei on 27/4/21.
//

import UIKit

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
    
    func fetchInterestingPhotos (_ type: PhotoType, completion: @escaping (Result<[Photo], Error>) -> Void) {
        var url: URL = URL(string: "http://defaultURL")! //TODO
        
        if type == .interestingPhotos {
            url = FlickrAPI.interestingPhotoURL
        } else if type == .recentPhotos {
            url = FlickrAPI.recentPhotoURL
        }
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
            print("Response data:")
            if let httpResponse = response as? HTTPURLResponse {
                print("\(httpResponse.statusCode)")
                print("\(httpResponse.allHeaderFields)")
            }
            let result = self.processPhotosRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    func fetchImage (for photo: Photo, completion: @escaping (Result<UIImage, Error>) -> Void) {
        /*guard let photoURL = photo.urlZ else {
            completion(.failure(PhotoError.missingImageURL))
            return
        }*/
        guard let requestURL = URL(string: photo.urlZ!)  else {
            completion(.failure(PhotoError.missingImageURL))
            return
        }
        let request = URLRequest(url: requestURL)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            let result = self.processImageRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    private func processImageRequest (data: Data?, error: Error?) -> Result<UIImage, Error> {
        guard let imageData = data,
              let image = UIImage(data: imageData) else {
            // Couldn't create an image
            if data == nil {
                return .failure(error!)
            } else {
                return .failure(PhotoError.imageCreationError)
            }
        }
        return .success(image)
    }
}

enum PhotoError: Error {
    case imageCreationError
    case missingImageURL
}

enum PhotoType {
    case interestingPhotos
    case recentPhotos
}
