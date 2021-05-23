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
            let _ = flickrPhotos.map { flickrPhoto -> Photo in
                let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
                let predicate = NSPredicate(format: "\(#keyPath(Photo.photoID)) == \(flickrPhoto.photoID)")
                fetchRequest.predicate = predicate
                var photo: Photo!
                context.performAndWait {
                        photo = Photo(context: context)
                        photo.photoID = flickrPhoto.photoID
                        photo.owner = flickrPhoto.owner
                        photo.secret = flickrPhoto.secret
                        photo.server = flickrPhoto.server
                        photo.farm = Int32(flickrPhoto.farm)
                        photo.title = flickrPhoto.title
                        photo.ispublic = Int32(flickrPhoto.ispublic)
                        photo.isfriend = Int32(flickrPhoto.isfriend)
                        photo.isfamily = Int32(flickrPhoto.isfamily)
                        photo.datetaken = flickrPhoto.datetaken
                        photo.datetakengranularity = flickrPhoto.datetakengranularity
                        photo.datetakenunknow = flickrPhoto.datetakenunknown
                        photo.urlZ = flickrPhoto.urlZ
                        photo.heightZ = Int32(flickrPhoto.heightZ!)
                        photo.widthZ = Int32(flickrPhoto.widthZ!)
                }
                return photo
            }
            return .success(flickrPhotos)
        case let .failure(error):
            return .failure(error)
        }
    }
    func fetchAllPhotos (completion: @escaping (Result<[Photo], Error>) -> Void) -> Void {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let sortByDataTaken = NSSortDescriptor(key: #keyPath(Photo.datetaken), ascending: true)
        fetchRequest.sortDescriptors = [sortByDataTaken]
        let viewContext = persistenContainer.viewContext
        viewContext.perform {
            do {
                let allPhotos = try viewContext.fetch(fetchRequest)
                completion(.success(allPhotos))
            } catch {
                completion(.failure(error))
            }
        }
    }
    func fetchRecentPhotos (completion: @escaping (Result<[FlickrPhoto], Error>) -> Void) {
        let url = FlickrAPI.interestingPhotoURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            var result = self.processPhotosRequest(data: data, error: error)
            if case .success = result {
                do {
                    try self.persistenContainer.viewContext.save()
                } catch {
                    result = .failure(error)
                }
            }
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }
    func fetchImage (for photo: Photo, completion: @escaping (Result<UIImage, Error>) -> Void) {
        
        let photoKey = photo.photoID
        if let image = imageStore.image(forKey: photoKey!) {
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
                self.imageStore.setImage(image, forKey: photoKey!)
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
