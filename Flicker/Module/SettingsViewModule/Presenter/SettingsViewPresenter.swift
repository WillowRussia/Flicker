//
//  SettingsViewPresenter.swift
//  Flicker
//
//  Created by Илья Востров on 20.12.2024.
//

protocol SettingsViewPresenterProtocol: AnyObject {
    init(view: SettingsViewProtocol)
}

class SettingsViewPresenter: SettingsViewPresenterProtocol {
    private weak var view: SettingsViewProtocol?
    
    required init(view: SettingsViewProtocol) {
        self.view = view
    }
    
}
