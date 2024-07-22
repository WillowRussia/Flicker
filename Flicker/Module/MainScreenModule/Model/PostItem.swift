//
//  PostItem.swift
//  Flicker
//
//  Created by Илья Востров on 22.07.2024.
//

import Foundation

class PostDate: Identifiable{
    let id = UUID().uuidString
    let items: [PostItem]
    let date: Date

    init(items: [PostItem], date: Date) {
        self.items = items
        self.date = date
    }

    static func getMockData() -> [PostDate] {
        [
            PostDate(items: [
                PostItem(photos: ["img1", "img2"], comments: nil, tags: ["Дом", "Nature"], description: "Lorem ipsum dolor sit amet, consectetur adipisicing elit"),
                PostItem(photos: ["img3"], comments: nil, tags: ["Nature","Home", "Education", "Work", "Game"], description: "tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam"),
                PostItem(photos: ["img3"], comments: nil, tags: ["Nature","Home", "Education", "Work", "Game"], description: "tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam")
            ], date: Date()),

            PostDate(items: [
                PostItem(photos: ["img2"], comments: nil, tags: ["Nature","Home", "Education", "Work", "Game"], description: "labore et dolore magna aliqua. Ut enim ad minim veniam"),
                PostItem(photos: ["img3"], comments: nil, tags: ["Nature","Home", "Education", "Work", "Game"], description: "Ut enim ad minim veniam tempor incididunt ut labore et dolore magna aliqua"),
            ], date: Date().addingTimeInterval(-86400)),

            PostDate(items: [
                PostItem(photos: ["img2", "img3"], comments: nil, tags: ["Nature","Home", "Education", "Work", "Game"], description: "labore et dolore magna aliqua"),
                PostItem(photos: ["img3"], comments: nil, tags: ["Nature","Home", "Education", "Work", "Game"], description: "labore et veniam tempor incididunt ut labore et dolore magna aliqua dolore magna aliqua"),
            ], date: Date().addingTimeInterval(-172800))
        ]
    }
}

class PostItem: Identifiable{
    let id = UUID().uuidString
    let photos: [String]
    let comments: [Commet]?
    let tags: [String]?
    let description: String?
    let isFavorite: Bool = false

    init(photos: [String], comments: [Commet]?, tags: [String]?, description: String?) {
        self.photos = photos
        self.comments = comments
        self.tags = tags
        self.description = description
    }
}

class Commet: Identifiable{
    let id = UUID().uuidString
    let date: Date
    let comment: String

    init(date: Date, comment: String) {
        self.date = date
        self.comment = comment
    }
}
