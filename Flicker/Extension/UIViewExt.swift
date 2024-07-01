//
//  UIView.ext.swift
//  Flicker
//
//  Created by Илья Востров on 28.06.2024.
//

import UIKit

extension UIView{
    static func configure<T: UIView>(view: T, block:@escaping (T) -> ())-> T{
        view.translatesAutoresizingMaskIntoConstraints = false
        block(view)
        return view
    }
}
