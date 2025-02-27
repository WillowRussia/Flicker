//
//  TabBarViewPresenter.swift
//  Flicker
//
//  Created by Илья Востров on 22.07.2024.
//

import UIKit

protocol TabBarViewPresenterProtocol: AnyObject{
    init(view: TabBarViewProtocol)
}

class TabBarViewPresenter: TabBarViewPresenterProtocol {

    weak var view: TabBarViewProtocol?

    required init(view: TabBarViewProtocol) {
        self.view = view

    }
}

