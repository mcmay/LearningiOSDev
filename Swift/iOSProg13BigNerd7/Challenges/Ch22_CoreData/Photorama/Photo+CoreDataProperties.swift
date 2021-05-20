//
//  Photo+CoreDataProperties.swift
//  Photorama
//
//  Created by Chao Mei on 20/5/21.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var datetaken: String?
    @NSManaged public var datetakengranularity: String?
    @NSManaged public var datetakenunknow: String?
    @NSManaged public var farm: Int64
    @NSManaged public var heightZ: Int64
    @NSManaged public var id: String?
    @NSManaged public var isfamily: Int64
    @NSManaged public var isfriend: Int64
    @NSManaged public var ispublic: Int64
    @NSManaged public var owner: String?
    @NSManaged public var secret: String?
    @NSManaged public var server: String?
    @NSManaged public var title: String?
    @NSManaged public var urlZ: String?
    @NSManaged public var widthZ: Int64

}

extension Photo : Identifiable {

}
