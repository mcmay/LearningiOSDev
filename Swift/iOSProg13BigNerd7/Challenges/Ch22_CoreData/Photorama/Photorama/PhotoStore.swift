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
                let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
                let predicate = NSPredicate(format: "\(#keyPath(Photo.id)) == \(flickrPhoto.id)")
                fetchRequest.predicate = predicate
                var photo: Photo!
                context.performAndWait {
                    do {
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
                        photo.datetakengranularity = try String(from: flickrPhoto.datetakengranularity as! Decoder)
                        photo.datetakenunknow = flickrPhoto.datetakenunknown
                        photo.urlZ = flickrPhoto.urlZ
                        photo.heightZ = Int64(flickrPhoto.heightZ!)
                        photo.widthZ = Int64(flickrPhoto.widthZ!)
                    } catch {
                        print("error encountered")
                    }
                }
                return photo
            }
            return .success(photos)
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
    func fetchImage (for photo: FlickrPhoto, completion: @escaping (Result<UIImage, Error>) -> Void) {
        
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
