//
//  StoreManager.swift
//  Flicker
//
//  Created by Илья Востров on 21.12.2024.
//

import Foundation

//protocol StoreManagerProtocol: AnyObject {
//    func savePhotos (postId: String, photos: [Data?]) -> [String]
//    func getPhotos (postId: String, photos: [String]) -> [Data]
//}

class StoreManager {
    
    static let shared = StoreManager()
    private init(){}
    
    private func getPath() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func savePhotos (postId: String, photos: [Data?]) -> [String] {
        var photoNames = [String]()
        photos.forEach{
            guard let photoData = $0 else { return }
            let photoName = savePhoto(postId: postId, photo: photoData)
            photoNames.append(photoName)
        }
        return photoNames
    }
    
    func getPhotos (postId: String, photos: [String]) -> [Data] {
        var photosData = [Data]()
        var path = getPath().appending(path: postId)
        photos.forEach {
            path.append(path: $0)
            
            if let photoData = try? Data (contentsOf: path){
                photosData.append(photoData)
            }
        }
        return photosData
    }
                                             
    private func savePhoto(postId: String, photo: Data) -> String{
        let name = UUID().uuidString + ".jpeg"
        
        var path = getPath().appending(path: postId)
        
        do {
            try FileManager.default.createDirectory(at: path, withIntermediateDirectories: true)
            path.append(path: name)
        } catch {
            print(error.localizedDescription)
        }
        do {
            try photo.write(to: path)
        } catch {
            print(error.localizedDescription)
        }
        
        return name
    }
}
