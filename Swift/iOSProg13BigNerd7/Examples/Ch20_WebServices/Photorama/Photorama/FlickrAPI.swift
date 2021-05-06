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
    
            return .success(flickrResponse.photoInfo.photo)
        } catch {
            return .failure(error)
        }
    }
}

struct FlickrResponse: Codable {
    //let photos: FlickrPhotosResponse
    let extra: Extra
    let stat: String
    let photoInfo: FlickrPhotosResponse
    
    enum CodingKeys: String, CodingKey {
        case stat, extra
        case photoInfo = "photos"
    }
}

struct FlickrPhotosResponse: Codable {
    
    let page, pages, perpage, total: Int
    let photo: [Photo] // This variable name "photo" must not be changed.
    // Or else, there will be problem with decoding json data
    
    enum CodingKyes: String, CodingKey {
        case page, pages, perpage, total
    }
}
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

// MARK: - Welcome
/*struct Welcome: Codable {
    let extra: Extra
    let photos: Photos
    let stat: String
}*/
// MARK: - Extra
struct Extra: Codable {
    let exploreDate: String
    let nextPreludeInterval: Int

    enum CodingKeys: String, CodingKey {
        case exploreDate = "explore_date"
        case nextPreludeInterval = "next_prelude_interval"
    }
}

// MARK: - Photos
/*struct Photos: Codable {
    let page, pages, perpage, total: Int
    let photo: [Photo]
}*/



