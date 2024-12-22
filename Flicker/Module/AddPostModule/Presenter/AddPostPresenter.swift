//
//  AddPostPresenter.swift
//  Flicker
//
//  Created by Илья Востров on 31.10.2024.
//

import UIKit

protocol AddPostPresenterProtocol: AnyObject {
    init(view: AddPostViewProtocol, photos: [UIImage])
    var photos: [UIImage] { get set }
    var tags: [String] { get set }
    var postDescription: String? {get set}
    func savePost()
}
class AddPostPresenter: AddPostPresenterProtocol {
    
    private weak var view: AddPostViewProtocol?
    private let coreManager = CoreManager.shared
    private let storageManager = StoreManager.shared
    
    var photos: [UIImage]
    private var photosData: [Data?] = []
    var tags: [String] = []
    var postDescription: String?
    
    
    required init(view: AddPostViewProtocol, photos: [UIImage]) {
        self.view = view
        self.photos = photos
    }
    
    func savePost() {
        
        let id = UUID() .uuidString
        
        photos.forEach{
            let imageData = $0.jpegData(compressionQuality: 1)
            photosData.append(imageData)
        }
    
        let photos = storageManager.savePhotos(postId: id, photos: photosData)
        
        
        let post: PostItem = {
            $0.id = id
            $0.photos = photos
            $0.comments = []
            $0.tags = self.tags
            $0.date = Date ()
            $0.isFavorite = false
            $0.postDescription = self.postDescription
            return $0
        }(PostItem(context: coreManager.persistentContainer.viewContext))
        coreManager.savePost(post: post)
    }
    
}
