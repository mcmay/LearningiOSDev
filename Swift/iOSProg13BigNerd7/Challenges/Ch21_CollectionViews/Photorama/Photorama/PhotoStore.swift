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
    let imageStore = ImageStore()
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
            OperationQueue.main.addOperation {
                completion(result) // Find the implementation of this completion method in
                // PhotosViewController.swift
            }
        }
        task.resume()
    }
    func fetchImage (for photo: Photo, completion: @escaping (Result<UIImage, Error>) -> Void) {
        /*guard let photoURL = photo.urlZ else {
            completion(.failure(PhotoError.missingImageURL))
            return
        }*/
        // image caching to smooth up loading of images in collection view cells
        let photoKey = photo.id
        if let image = imageStore.image(forKey: photoKey) {
            OperationQueue.main.addOperation { // This completion task must run on main thread
                completion(.success(image))
            }
            return
        }
        guard let photoURL = photo.urlZ else { return }
        guard let requestURL = URL(string: photoURL)  else {
            completion(.failure(PhotoError.missingImageURL))
            return
        }
        let request = URLRequest(url: requestURL)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            let result = self.processImageRequest(data: data, error: error)
            if case let .success(image) = result {
                self.imageStore.setImage(image, forKey: photoKey)
            }
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
