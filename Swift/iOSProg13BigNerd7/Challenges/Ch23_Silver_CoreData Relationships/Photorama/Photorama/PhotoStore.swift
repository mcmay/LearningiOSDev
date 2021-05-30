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
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Photorama")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error setting up Core Data (\(error))")
            }
        }
        return container
    }()
    func fetchRecentPhotos (completion: @escaping (Result<[Photo], Error>) -> Void) {
        let url = FlickrAPI.recentPhotoURL
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            /*var result = self.processPhotosRequest(data: data, error: error)
                
            if case .success = result {
                do {
                    if self.persistentContainer.viewContext.hasChanges {
                        try self.persistentContainer.viewContext.save()
                    }
                } catch {
                    result = .failure(error)
                }
            }
            OperationQueue.main.addOperation {
                completion(result)
            }*/
            self.processPhotosRequest(data: data, error: error, completion: {
                (result) in
                
                OperationQueue.main.addOperation {
                    completion(result)
                }
            })
        }
        task.resume()
    }
    //var counter = 0
    private func processPhotosRequest (data: Data?, error: Error?,
                                       completion: @escaping (Result<[Photo], Error>) -> Void) {
        guard let jsonData = data else {
            completion(.failure(error!))
            return
        }
        
        //let context = persistentContainer.viewContext
        persistentContainer.performBackgroundTask {
            (context) in
        
            switch FlickrAPI.photos(fromJSON: jsonData) {
            case let .success(flickrPhotos): // .success(flickrPhotos) are returned from FlickrAPI.photos(fromJSON:)
                //print(#function, "flickrPhotos: \(flickrPhotos.count)") // 100 2021-5-30
                let photos = flickrPhotos.map { flickrPhoto -> Photo in
                    let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
                    let predicate = NSPredicate(format: "(\(#keyPath(Photo.photoID)) == \(flickrPhoto.photoID)) AND (NOT \(#keyPath(Photo.title)) BEGINSWITH 'D-2021')")
                    fetchRequest.predicate = predicate
                    var fetchedPotos: [Photo]?
                    context.performAndWait {
                        fetchedPotos = try? fetchRequest.execute()
                        //print(#function, "fetchedPhotos: \(fetchedPotos?.count ?? 0)") // 0 or 1 2021-5-30
                    }
                    if let existingPhoto = fetchedPotos?.first {
                        //print(#function, "counter: \(self.counter)")
                        //self.counter += 1 // 52 2021-5-30
                        return existingPhoto
                    }
                    var photo: Photo!
                    context.performAndWait {
                        photo = Photo(context: context)
                        photo.photoID = flickrPhoto.photoID
                        photo.title = flickrPhoto.title
                        photo.datetaken = flickrPhoto.datetaken
                        photo.urlZ = flickrPhoto.urlZ
                        if let photoHeight = flickrPhoto.heightZ {
                                photo.heightZ = Int32(photoHeight)
                        } else {
                            photo.heightZ = 90
                        }
                        if let photoWidth = flickrPhoto.widthZ {
                            photo.heightZ = Int32(photoWidth)
                        } else {
                            photo.widthZ = 90
                        }
                    }
                    return photo
                }
                do {
                    try context.save()
                } catch {
                    print("Error saving to Core Data: \(error)")
                    completion(.failure(error))
                    return
                }
                let photoIDs = photos.map { $0.objectID }
                let viewContext = self.persistentContainer.viewContext
                let viewContextPhotos = photoIDs.map {viewContext.object(with: $0) } as! [Photo]
                completion(.success(viewContextPhotos))
                
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    func fetchAllPhotosFromDisk (completion: @escaping (Result<[Photo], Error>) -> Void) -> Void {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "(\(#keyPath(Photo.hide)) == \(false)) AND (NOT \(#keyPath(Photo.title)) BEGINSWITH 'D-2021') AND (NOT \(#keyPath(Photo.title)) BEGINSWITH 'ha_2021')")
        fetchRequest.predicate = predicate
        let sortByDataTaken = NSSortDescriptor(key: #keyPath(Photo.datetaken), ascending: false)
        fetchRequest.sortDescriptors = [sortByDataTaken]
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            do {
                let allPhotos = try viewContext.fetch(fetchRequest)
                completion(.success(allPhotos))
            } catch {
                completion(.failure(error))
            }
        }
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
    func fetchAllTags (completion: @escaping (Result<[Tag], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<Tag> = Tag.fetchRequest()
        let sortByName = NSSortDescriptor(key: #keyPath(Tag.name), ascending: true)
        fetchRequest.sortDescriptors = [sortByName]
        
        let viewContext = persistentContainer.viewContext
        viewContext.perform {
            do {
                let allTags = try fetchRequest.execute()
                    completion(.success(allTags))
            } catch {
                    completion(.failure(error))
            }
        }
    }
}

enum PhotoError: Error {
    case imageCreationError
    case missingImageURL
}
