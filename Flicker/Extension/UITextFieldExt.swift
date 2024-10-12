//
//  UITextFieldExt.swift
//  Flicker
//
//  Created by Илья Востров on 10.10.2024.
//

import UIKit

extension UITextField { //Добавляет отступ слева
    func setLeftOffSet(){
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 10))
        self.leftViewMode = .always
    }
}
