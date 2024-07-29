//
//  DataExt.swift
//  Flicker
//
//  Created by Илья Востров on 22.07.2024.
//

import UIKit
//Преобразует дату в слова
extension Date{
    func getDateDiference() -> String {
        let curentDateInterval = Int(Date().timeIntervalSinceReferenceDate)
        let dateDifferences = Double(curentDateInterval - Int(self.timeIntervalSinceReferenceDate))
        let dateDifferencesDate = Int(round(dateDifferences/86400))

        switch dateDifferencesDate {
        case 0:
            return "Cегодня"
        case 1:
            return "Вчера"
        case 2...4:
            return "\(dateDifferencesDate) дня назад"
        default:
            return "\(dateDifferencesDate) дней назад"
        }
    }
}
