//
//  PhotoStore.swift
//  Photorama
//
//  Created by Chao Mei on 27/4/21.
//

import UIKit
import CoreData

class PhotoStore {
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    let imageStore = ImageStore()
    let persistenContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Photorama")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error setting up Core Data (\(error))")
            }
        }
        return container
    }()
    private func processPhotosRequest (data: Data?, error: Error?) ->
    Result<[FlickrPhoto], Error> {
        guard let jsonData = data else {
            return .failure(error!)
        }
        //return FlickrAPI.photos(fromJSON: jsonData)
        let context = persistenContainer.viewContext
        
        switch FlickrAPI.photos(fromJSON: jsonData) {
        case let .success(flickrPhotos):
            let photos = flickrPhotos.map { flickrPhoto -> Photo in
                var photo: Photo!
                context.performAndWait {
                        photo = Photo(context: context)
                        photo.id = flickrPhoto.id
                        photo.owner = flickrPhoto.owner
                        photo.secret = flickrPhoto.secret
                        photo.server = flickrPhoto.server
                        photo.farm = Int64(flickrPhoto.farm)
                        photo.title = flickrPhoto.title
                        photo.ispublic = Int64(flickrPhoto.ispublic)
                        photo.isfriend = Int64(flickrPhoto.isfriend)
                        photo.isfamily = Int64(flickrPhoto.isfamily)
                        photo.datetaken = flickrPhoto.datetaken
                        photo.datetakengranularity = String(from: flickrPhoto.datetakengranularity)
                        photo.datetakenunknow = flickrPhoto.datetakenunknown
                        photo.urlZ = flickrPhoto.urlZ
                        photo.heightZ = Int64(flickrPhoto.heightZ!)
                        photo.widthZ = Int64(flickrPhoto.widthZ!)
                   
                }
                
            }
            
        default:
            <#code#>
        }
    }
    
    func fetchInterestingPhotos (completion: @escaping (Result<[FlickrPhoto], Error>) -> Void) {
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
                completion(result)
            }
        }
        task.resume()
    }
    func fetchImage (for photo: FlickrPhoto, completion: @escaping (Result<UIImage, Error>) -> Void) {
        /*guard let photoURL = photo.urlZ else {
            completion(.failure(PhotoError.missingImageURL))
            return
        }*/
        /*
         The Big Nerd Ranch Guide book says when using the core data model
         all the values to be saved in the model should be an optional
         in the code. Hence, this guard let statement to unwrap the
         Optional photo.id. However, in practice in my code, there seems
         to be no such need. The compiler or runtime seems to have solved
         this hassle.
         
         guard let photoKey = photo.id else {
            preconditionFailure("Photo expected to have an id.")
        }*/
        let photoKey = photo.id
        if let image = imageStore.image(forKey: photoKey) {
            OperationQueue.main.addOperation {
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
