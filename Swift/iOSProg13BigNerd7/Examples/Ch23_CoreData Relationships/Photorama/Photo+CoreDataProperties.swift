//
//  Photo+CoreDataProperties.swift
//  Photorama
//
//  Created by Chao Mei on 28/5/21.
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
    @NSManaged public var tags: NSSet?

}

// MARK: Generated accessors for tags
extension Photo {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}

extension Photo : Identifiable {

}
