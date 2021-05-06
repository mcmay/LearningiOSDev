//
//  Photo.swift
//  Photorama
//
//  Created by Chao Mei on 1/5/21.
//

import Foundation

/*class Photo: Codable {
    let title: String
    let remoteURL: URL
    let photoID: String
    let dateTaken: Date
    
    public init (title: String, remoteURL: URL, photoID: String, dateTaken: Date) {
        self.title = title
        self.remoteURL = remoteURL
        self.photoID = photoID
        self.dateTaken = dateTaken
    }
    
    enum CodingKeys: String, CodingKey {
        case title
        case remoteURL = "url_z"
        case photoID = "id"
        case dateTaken = "datetaken"
    }
}*/
// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
    let datetaken: String
    let datetakengranularity: Datetakengranularity
    let datetakenunknown: String
    let urlZ: String
    let heightZ, widthZ: Int

    enum CodingKeys: String, CodingKey {
        case id, owner, secret, server, farm, title, ispublic, isfriend, isfamily, datetaken, datetakengranularity, datetakenunknown
        case urlZ = "url_z"
        case heightZ = "height_z"
        case widthZ = "width_z"
    }
}
enum Datetakengranularity: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Datetakengranularity.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Datetakengranularity"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

