//
//  DetailsViewPresenter.swift
//  Flicker
//
//  Created by Илья Востров on 02.08.2024.
//

import UIKit

protocol DetailsViewPresenterProtocol: AnyObject {
    init(view: DetailsViewProtocol, item: PostItem)
    var item: PostItem {get}
}

class DetailsViewPresenter: DetailsViewPresenterProtocol {
    
    var item: PostItem
    
    private weak var view: DetailsViewProtocol?
    
    required init(view: DetailsViewProtocol, item: PostItem) {
        self.view = view
        self.item = item
    }
    
    
}
