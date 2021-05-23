//
//  Photo+CoreDataProperties.swift
//  Photorama
//
//  Created by Chao Mei on 23/5/21.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var datetaken: String?
    @NSManaged public var datetakengranularity: NSObject?
    @NSManaged public var datetakenunknow: String?
    @NSManaged public var farm: Int32
    @NSManaged public var heightZ: Int32
    @NSManaged public var photoID: String?
    @NSManaged public var isfamily: Int32
    @NSManaged public var isfriend: Int32
    @NSManaged public var ispublic: Int32
    @NSManaged public var owner: String?
    @NSManaged public var secret: String?
    @NSManaged public var server: String?
    @NSManaged public var title: String?
    @NSManaged public var urlZ: String?
    @NSManaged public var widthZ: Int32

}

extension Photo : Identifiable {

}
