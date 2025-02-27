//
//  NSNotificationName.swift
//  Flicker
//
//  Created by Илья Востров on 12.10.2024.
//

import Foundation

extension NSNotification.Name {
    static let hideTabBar = NSNotification.Name("hideTabBAr") // Название модификации
    static let goToMain = NSNotification.Name("goToMain") // Название модификации
    static let dismissPascode = NSNotification.Name("dismissPascode") // Скрытие окна pascode
    static let dismissCameraView = NSNotification.Name ("dismissCameraView") // Закрытие окна при сохранении
    static let dataDidUpdate = NSNotification.Name("dataDidUpdate")
}
