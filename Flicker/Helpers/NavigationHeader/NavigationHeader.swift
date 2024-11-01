//
//  NavigationHeader.swift
//  Flicker
//
//  Created by Илья Востров on 02.08.2024.
//

import UIKit

protocol NavigationHeaderProtocol: AnyObject {
    
}
class NavigationHeader: NavigationHeaderProtocol {
    // Обьявление действий для кнопок
    var backAction: UIAction?
    var menuAction: UIAction?
    var closeAction: UIAction?
    var date: Date
    
    private lazy var navigationView: UIView = { // Вьюха для размещения всех обьектов
        $0.frame = CGRect(x: 30, y: 0, width: UIScreen.main.bounds.width -  60, height: 44)
        $0.backgroundColor = .appMain
        return $0
    }(UIView())
    lazy var dateLabel: UILabel = getHeaderLabel(text: date.formatDate(formatType: .onlyDate), size: 25, weight: .bold)
    lazy var yearLabel: UILabel = getHeaderLabel(text: date.formatDate(formatType: .onlyYear) + " год", size: 14, weight: .light)
    lazy var backButton: UIButton = getActionButton(origin: CGPoint(x: 0, y: 11), icon: .backIcon, action: backAction)
    lazy var menuButton: UIButton = getActionButton(origin: CGPoint(x: navigationView.frame.width - 30, y: 11), icon: .menuIcon, action: menuAction)
    lazy var closeButton: UIButton = getActionButton(origin: CGPoint(x: navigationView.frame.width - 30, y: 11), icon: .closeIcon, action: closeAction)
    
    lazy var dateStack: UIStackView = { // Стек с датой
        $0.axis = .vertical
        $0.addArrangedSubview(dateLabel)
        $0.addArrangedSubview(yearLabel)
        return $0
    }(UIStackView(frame: CGRect(x: 45, y: 0, width: 200, height: 44)))
    
    init(backAction: UIAction? = nil, menuAction: UIAction? = nil, closeAction: UIAction? = nil, date: Date) {
        self.backAction = backAction
        self.menuAction = menuAction
        self.closeAction = closeAction
        self.date = date
    }
    
    func getNavigationHeader(type: NavigationHeaderType) -> UIView {
        switch type {
        case .back:
            navigationView.addSubview(dateStack)
            navigationView.addSubview(backButton)
            navigationView.addSubview(menuButton)
        case .close:
            navigationView.addSubview(backButton)
        }
        return navigationView
    }
    //Функция для создания кнопки в AppBar
    private func getActionButton(origin: CGPoint, icon: UIImage, action: UIAction?) -> UIButton {
        let button = UIButton(primaryAction: action)
        button.frame.size = CGSize(width: 25, height: 25)
        button.frame.origin = origin
        button.setBackgroundImage(icon, for: .normal)
        return button
    }
  
    //Функция для создания строки в AppBar
    private func getHeaderLabel(text: String, size: CGFloat, weight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: size, weight: weight)
        return label
    }
    
}

enum NavigationHeaderType{
    case back, close
}
