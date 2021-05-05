//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Chao Mei on 24/4/21.
//

import Foundation

enum EndPoint: String {
    case interestingPhotos = "flickr.interestingness.getList"
}
/*
 https://api.flickr.com/services/rest/?method=flickr.interestingness.getList
 &api_key=a6d819499131071f158fd740860a5a88&extras=url_z,date_taken
 &format=json&nojsoncallback=1
 */
struct FlickrAPI {
    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let apiKey = "a6d819499131071f158fd740860a5a88"
    
    // assemble url from baseURLString and query items
    private static func flickrURL (endPoint: EndPoint, parameters: [String: String]?) -> URL {
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        let baseParams = [
            "method": endPoint.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": apiKey
        ]
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        if let addtionalParams = parameters {
            for (key, value) in addtionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        
        return components.url!
    }
    static var interestingPhotoURL: URL {
        // url_z is a URL shortener (zipper) for convenience and beauty
        return flickrURL(endPoint: .interestingPhotos,
                         parameters: ["extras": "url_z,date_taken"])
    }
    static func photos (fromJSON data: Data) -> Result<[Photo], Error> {
        do {
            let decoder = JSONDecoder()
            let flickrResponse = try decoder.decode(FlickrResponse.self, from: data)
    
            return .success(flickrResponse.photosInfo.photos)
        } catch {
            return .failure(error)
        }
    }
}

struct FlickrResponse: Codable {
    //let photos: FlickrPhotosResponse
    let photosInfo: FlickrPhotosResponse
    
    enum CodingKeys: String, CodingKey {
        case photosInfo = "photos"
    }
}

struct FlickrPhotosResponse: Codable {
    //let photo: [Photo]
    let photos: [Photo]
    
    enum CodingKyes: String, CodingKey {
        case photos = "photo"
    }
}
