//
//  UIView.ext.swift
//  Flicker
//
//  Created by Илья Востров on 28.06.2024.
//

import UIKit

extension UIView{
    // Метод для настройки констрентов
    static func configure<T: UIView>(view: T, block:@escaping (T) -> ())-> T{
        view.translatesAutoresizingMaskIntoConstraints = false//Это свойство автоматически создает ограничения для view, поэтому нам надо ставить его в значение false, когда мы хотим сами посатвить ограничения
        block(view)
        return view
    }
    // Метод для добавления тени на основную ячейку
    func setViewGradient(frame: CGRect, startPoint: CGPoint, endPoint: CGPoint, colors: [UIColor], locations: [NSNumber]) {
        
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = colors.map{
            $0.cgColor
        }
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.locations = locations
        
        self.layer.addSublayer(gradient)
    }
}
