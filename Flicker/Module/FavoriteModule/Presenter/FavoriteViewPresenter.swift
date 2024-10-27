//
//  FavoriteViewPresenter.swift
//  Flicker
//
//  Created by Илья Востров on 29.07.2024.
//

import UIKit

protocol FavoriteViewPresenterProtocol: AnyObject {
    init(view: FavotiteViewProtocol)
    var post: [PostItem]? {get set}
    func getPost()

}

class FavoriteViewPresenter: FavoriteViewPresenterProtocol {
    
    var post: [PostItem]?
    
    
    private weak var view: FavotiteViewProtocol?
    
    required init(view: FavotiteViewProtocol) {
        self.view = view
        getPost()
    }
    
    func getPost() {
        self.post = PostItem.getMockItems()
        self.view?.showPost()
    }
    
    
}
