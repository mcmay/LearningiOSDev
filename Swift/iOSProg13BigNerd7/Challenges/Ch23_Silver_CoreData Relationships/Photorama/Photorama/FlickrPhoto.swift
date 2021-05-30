//
//  Photo.swift
//  Photorama
//
//  Created by Chao Mei on 1/5/21.
//

import Foundation

// MARK: - Photo
struct FlickrPhoto: Codable {
    let photoID, title, datetaken: String
    let urlZ: String?
    let heightZ, widthZ: Int?

    enum CodingKeys: String, CodingKey {
        case title, datetaken
        case photoID = "id"
        case urlZ = "url_z"
        case heightZ = "height_z"
        case widthZ = "width_z"
    }
}

extension FlickrPhoto: Equatable {
    static func == (lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
        // Two Photos are the same if they have the same photoID
        return lhs.photoID == rhs.photoID
    }
}
