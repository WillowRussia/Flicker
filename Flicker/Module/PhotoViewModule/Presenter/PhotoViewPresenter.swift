//
//  PhotoViewPresenter.swift
//  Flicker
//
//  Created by Илья Востров on 12.10.2024.
//

import UIKit

protocol PhotoViewPresenterProtocol: AnyObject {
    init(view: PhotoViewProtocol, image: UIImage?)
    var image: UIImage? {get set}
}
class PhotoViewPresenter: PhotoViewPresenterProtocol {
    
    var image: UIImage?
    private weak var view: PhotoViewProtocol?
    
    required init(view: PhotoViewProtocol, image: UIImage?) {
        self.view = view
        self.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


        
    
    


}
