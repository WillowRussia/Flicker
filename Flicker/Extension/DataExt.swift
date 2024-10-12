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
    
    //Расшифровывает дату в слова
    func formatDate(formatType: DateFormatType) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU") // Устанавливаем локализацию
        
        switch formatType {
        case .full:
            formatter.dateFormat = "dd MMMM yyyy"
        case .onlyDate:
            formatter.dateFormat = "dd MMMM"
        case .onlyYear:
            formatter.dateFormat = "yyyy"
        }
        
        //LLL - сокращено без склонений, LLLL - полностью без склонений
        //MMM - сокращено cо склонениями, MMMM - полностью со склонениями
        return formatter.string(from: self)
    }
}

enum DateFormatType {
    case full, onlyDate, onlyYear
}
