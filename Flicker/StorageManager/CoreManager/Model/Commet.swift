//
//  Commet+CoreDataClass.swift
//  Flicker
//
//  Created by Илья Востров on 21.12.2024.
//
//

import Foundation
import CoreData

@objc(Comment)
public class Comment: NSManagedObject {

}

extension Comment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comment> {
        return NSFetchRequest<Comment>(entityName: "Comment")
    }

    @NSManaged public var id: String?
    @NSManaged public var date: Date?
    @NSManaged public var comment: String?
    @NSManaged public var parant: PostItem?

}

extension Comment : Identifiable {

}
