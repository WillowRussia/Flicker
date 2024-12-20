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
            }
        }
        
        cell.backgroundColor = .clear
        cell.selectionStyle = .none // Убираем цвет при выборе
        return cell
    }
    
}
