//
//  PostData+CoreDataClass.swift
//  Flicker
//
//  Created by Илья Востров on 21.12.2024.
//
//

import Foundation
import CoreData

@objc(PostData)
public class PostData: NSManagedObject {

}

extension PostData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostData> {
        return NSFetchRequest<PostData>(entityName: "PostData")
    }

    @NSManaged public var id: String
    @NSManaged public var date: Date
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension PostData {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: PostItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: PostItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension PostData : Identifiable {

}
