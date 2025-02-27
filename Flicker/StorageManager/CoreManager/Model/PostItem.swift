//
//  PostItem+CoreDataClass.swift
//  Flicker
//
//  Created by Илья Востров on 21.12.2024.
//
//

import Foundation
import CoreData

@objc(PostItem)
public class PostItem: NSManagedObject {

}

extension PostItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PostItem> {
        return NSFetchRequest<PostItem>(entityName: "PostItem")
    }

    @NSManaged public var id: String
    @NSManaged public var photos: [String]?
    @NSManaged public var tags: [String]?
    @NSManaged public var postDescription: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var date: Date
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var parent: PostData?
    @NSManaged public var comments: NSSet?

}

// MARK: Generated accessors for comments
extension PostItem {

    @objc(addCommentsObject:)
    @NSManaged public func addToComments(_ value: Comment)

    @objc(removeCommentsObject:)
    @NSManaged public func removeFromComments(_ value: Comment)

    @objc(addComments:)
    @NSManaged public func addToComments(_ values: NSSet)

    @objc(removeComments:)
    @NSManaged public func removeFromComments(_ values: NSSet)

}

extension PostItem : Identifiable {
    
    func toggleFavorite (isFavorite: Bool){
        self.isFavorite = !isFavorite
        do {
            try managedObjectContext?.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
