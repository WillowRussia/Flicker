//
//  UIImageExt.swift
//  Flicker
//
//  Created by Илья Востров on 21.12.2024.
//

import UIKit

extension UIImage {
    
    static func getCoverPhoto(folderId: String, photos: [String]?) -> UIImage? {
        let imagesName = StoreManager.shared.getPhotos(postId: folderId, photos: photos ?? [])
        
        if let photoData = imagesName.first {
            return UIImage(data: photoData)
        }
        return nil
    }
    
    static func getOneImage (folderId: String, photo: String) -> UIImage? {
        let imageName = StoreManager.shared.getPhoto(postId: folderId, imageName: photo)
        guard let imageName else { return nil}
        return UIImage(data: imageName)
    }
}
