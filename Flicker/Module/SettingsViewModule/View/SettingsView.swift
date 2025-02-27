//
//  SettingView.swift
//  Flicker
//
//  Created by Илья Востров on 20.12.2024.
//

import UIKit

protocol SettingsViewProtocol: AnyObject {
    var tableView: UITableView {get set}
}

class SettingsView: UIViewController, SettingsViewProtocol {
    
    lazy var tableView: UITableView = {
        $0.dataSource = self
        $0.backgroundColor = .appBlack
        $0.separatorStyle = .none
        $0.register(SettingCell.self, forCellReuseIdentifier: SettingCell.reuseId)
        return $0
    }(UITableView(frame: view.bounds, style: .insetGrouped))
    
    var presenter: SettingsViewPresenterProtocol!
    private let coreManager = CoreManager.shared
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = .appMain
        navigationController?.navigationBar.backgroundColor = .appBlack
        
        navigationController?.navigationBar.titleTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
        NSAttributedString.Key.foregroundColor: UIColor.white
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad ()
        view.addSubview(tableView)
        
        title = "Настройки"
        
        view.backgroundColor = .appBlack
        
    }
}

extension SettingsView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SettigItems.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingCell.reuseId, for: indexPath) as! SettingCell
        
        let cellItem = SettigItems.allCases[indexPath.row]
        cell.cellSetup(cellType: cellItem)
        
        cell.completion = {
            if indexPath.row == 0{
                let passcodeVC = Builder.getPasscodeController(passcodeState: .setNewPasscode, sceneDelegate: nil, isSetting: true)
                self.present(passcodeVC, animated: true)
            } else if indexPath.row == 1 {
                self.showDeletionAlert(on: self) {
                    self.coreManager.deletePostDataWithPhotos()
                }
            }
        }
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none // Убираем цвет при выборе
        return cell
    }
    
}

extension SettingsView {
    func showDeletionAlert(on viewController: UIViewController, completion: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "Внимание!",
            message: "Это действие необратимо. Вы уверены, что хотите продолжить?",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            completion() // Выполняем действие после подтверждения
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
