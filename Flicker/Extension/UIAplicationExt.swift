//
//  UIAplicationExt.swift
//  Flicker
//
//  Created by Илья Востров on 22.07.2024.
//

import UIKit
//Высчитывание растояние до рабочей области
extension UIApplication {
    static var topSafeArea: CGFloat {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scene?.windows.first?.safeAreaInsets.top ?? .zero
    }
}
