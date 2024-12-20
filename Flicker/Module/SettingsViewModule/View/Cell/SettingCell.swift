//
//  SettingCell.swift
//  Flicker
//
//  Created by Илья Востров on 20.12.2024.
//

import UIKit

class SettingCell: UITableViewCell {

    static let reuseId = "SettingCell"
    
    var completion: ( () -> () )? // Замыкание для обработки нажатия на кнопку
    
    private lazy var cellView: UIView = {
        .configure(view: $0) { view in
            view.backgroundColor = .appMain
            view.layer.cornerRadius = 30
            view.clipsToBounds = true
            view.addSubview(self.cellStack)
        }
    } (UIView())
    
    private lazy var cellStack: UIStackView = {
        .configure (view: $0) { stack in
            stack.axis = .horizontal
            stack.alignment = .center
            stack.distribution = .equalSpacing //Чтобы по бокам
            stack.addArrangedSubview(self.cellLabel)
        }
    }(UIStackView())
    
    private lazy var nextButton: UIButton = {
        .configure(view: $0) { Button in
            Button.widthAnchor.constraint(equalToConstant: 18).isActive = true
            Button.heightAnchor.constraint(equalToConstant: 25).isActive = true
            Button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            Button.tintColor = .white
        }
    }(UIButton(primaryAction: nextButtonAction))
    
    private lazy var cellLabel: UILabel = {
            .configure(view: $0) { label in
                label.textColor = .white
            }
    }(UILabel())
    
    private lazy var locationSwitch: UISwitch = {
            $0.onTintColor = .black
            return $0
    }(UISwitch())
    
    private lazy var nextButtonAction = UIAction { [weak self] _ in
            self?.completion?()
    }
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cellView) // Если без ContentView, то она будет накрывать ячейку, не давая нажимать на нее
        contentView.backgroundColor = .clear
                
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            cellStack.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 15),
            cellStack.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -15),
            
            cellStack.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 20),
            cellStack.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -20),
        ])
    }
    
    func cellSetup(cellType: SettigItems){
            switch cellType{
            case .password, .delete:
                cellStack.addArrangedSubview(nextButton)
            case .loacation:
                cellStack.addArrangedSubview(locationSwitch)
            }
            
            cellLabel.text = cellType.rawValue
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
