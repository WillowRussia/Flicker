//
//  PasscodePresenter.swift
//  Flicker
//
//  Created by Илья Востров on 25.06.2024.
//

import UIKit

protocol PasscodePresenterProtocol: AnyObject {
    
    var isSetting: Bool { get set }
    var passcode: [Int] {get set}
    var templatePasscode: [Int]? {get set}
    func enterPasscode(number: Int)
    func removeLastItemInPasscode()
    func setNewPasscode()
    func checkPasscode()
    func clearPasscode(state: PasscodeState)
    
    init(view: PasscodeViewProtocol, passcodeState: PasscodeState, keychainManager: KeychainManagerProtocol, sceneDelagate: SceneDelegateProtocol?, isSetting: Bool)
}

class PasscodePresenter: PasscodePresenterProtocol {
    
    var isSetting: Bool
    
    var passcode: [Int] = [] {
        didSet{
            if passcode.count == 4 {
                switch passcodeState {
                case .inputPasscode:
                    self.checkPasscode()
                case .setNewPasscode:
                    self.setNewPasscode()
                default:
                    break
                }
            }
            
        }
    }
    var templatePasscode: [Int]?
    weak var view: PasscodeViewProtocol?
    var passcodeState: PasscodeState
    var keychainManager: KeychainManagerProtocol
    var sceneDelagate: SceneDelegateProtocol?
    
    
    required init(view: PasscodeViewProtocol, passcodeState: PasscodeState, keychainManager: KeychainManagerProtocol, sceneDelagate: SceneDelegateProtocol?, isSetting: Bool){
        self.view = view
        self.passcodeState = passcodeState
        self.keychainManager = keychainManager
        self.sceneDelagate = sceneDelagate
        self.isSetting = isSetting
        
        view.passcodeState(state: passcodeState)
    }
    
    func enterPasscode(number: Int) {
        if passcode.count < 4{
            self.passcode.append(number)
            view?.enterCode(code: passcode)
        }
        
    }
    
    func removeLastItemInPasscode() {
        if !passcode.isEmpty {
            self.passcode.removeLast()
            view?.enterCode(code: passcode)
        }
        
    }
    
    func setNewPasscode() {
        if templatePasscode != nil{
            if passcode == templatePasscode{
                let stringPasscode = passcode.map{String($0)}.joined()
                keychainManager.save(key: KeychainKeys.passcode.rawValue, value: stringPasscode)
                if isSetting {
                    NotificationCenter.default.post(name: .dismissPascode, object: nil)
                } else {
                    passcodeState = .inputPasscode
                    self.clearPasscode(state: .inputPasscode) // Очищаем статус
                }
            } else {
                self.view?.passcodeState(state: .codeMismatch)
            }
        } else {
            templatePasscode = passcode
            self.clearPasscode(state: .repeatPasscode)
        }
        
    }
    
    func checkPasscode() {
        let keychainPasscodeResult = keychainManager.load(key: KeychainKeys.passcode.rawValue)
        switch keychainPasscodeResult {
            
        case .success(let code):

            if self.passcode == code.digits {
                self.sceneDelagate?.startMainScreen()
            } else{
                self.clearPasscode(state: .wrongPasscode)
            }
        case .failure(let err):
            print(err.localizedDescription)
        }
    
    }
    
    func clearPasscode(state: PasscodeState) {
        self.passcode = []
        self.view?.enterCode(code: [])
        self.view?.passcodeState(state: state)
    }
    
    
    
}

// MARK: Состояния для окна
enum PasscodeState: String {
    case inputPasscode, wrongPasscode, setNewPasscode, repeatPasscode, codeMismatch
    
    func getPasscodeLabel() -> String {
        switch self{
        case .inputPasscode:
            return "Введите код"
        case .wrongPasscode:
            return "Неверный код"
        case .setNewPasscode:
            return "Установите код"
        case .repeatPasscode:
            return "Повторите код"
        case .codeMismatch:
            return "Коды не совпадают"
        }
        
    }
}
