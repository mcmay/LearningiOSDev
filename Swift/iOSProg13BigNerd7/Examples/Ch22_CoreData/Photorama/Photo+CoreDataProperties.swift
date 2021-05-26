//
//  Photo+CoreDataProperties.swift
//  Photorama
//
//  Created by Chao Mei on 26/5/21.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var datetaken: String?
    @NSManaged public var heightZ: Int32
    @NSManaged public var photoID: String?
    @NSManaged public var title: String?
    @NSManaged public var urlZ: String?
    @NSManaged public var widthZ: Int32

}

extension Photo : Identifiable {

}
