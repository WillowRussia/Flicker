//
//  DataExt.swift
//  Flicker
//
//  Created by Илья Востров on 22.07.2024.
//

import UIKit

extension Date{
    //Преобразует дату в слова
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
    
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU") // Устанавливаем локализацию
        formatter.dateFormat = "dd LLL yyyy"//LLL - сокращено, LLLL - полностью
        return formatter.string(from: self)
    }
}
