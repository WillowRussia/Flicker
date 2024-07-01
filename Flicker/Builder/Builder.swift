//
//  Builder.swift
//  Flicker
//
//  Created by Илья Востров on 25.06.2024.
//

import UIKit

protocol BuilderProtocol {
    static func getPasscodeController(passcodeState: PasscodeState) -> UIViewController
    
}
class Builder: BuilderProtocol {

    static func getPasscodeController(passcodeState: PasscodeState) -> UIViewController {
        let passcodeView = PasscodeView()
        let keychainManager = KeychainManager()
        let presenter = PasscodePresenter(view: passcodeView, passcodeState: passcodeState, keychainManager: keychainManager)
        
        passcodeView.passcodePresenter = presenter
        return passcodeView
        
    }
}
