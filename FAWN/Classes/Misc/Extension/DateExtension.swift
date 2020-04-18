//
//  DateExtension.swift
//  SleepWell
//
//  Created by Andrey Chernyshev on 25/10/2019.
//  Copyright © 2019 Andrey Chernyshev. All rights reserved.
//

import Foundation

extension Date {
    static func from(yyyyMMddHHmmss: String) -> Date? {
        return Date.yyyyMMddHHmmss.date(from: yyyyMMddHHmmss)
    }

    func getDateStr() -> String {
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: self)
        let date2 = calendar.startOfDay(for: Date())

        let components = calendar.dateComponents([.day], from: date1, to: date2)

        switch components.day  {
        case 0:
            return "today".localized
        case 1:
            return "yesterday".localized
        default:
            if calendar.component(.weekOfYear, from: date1) == calendar.component(.weekOfYear, from: date2) {
                return self.getWeekDay(date: date1)
            } else if calendar.component(.year, from: date1) == calendar.component(.year, from: date2) {
                return self.getDateStrWithMonth(date: date1)
            } else {
                return self.getDateStrWithYear(date: date1)
            }
        }
    }

    private func getDateStrWithYear(date: Date) -> String {
        return self.getDateStrWithMonth(date: date) + " \(Calendar.current.component(.year, from: date))"
    }

    private func getDateStrWithMonth(date: Date) -> String {
        let month = Calendar.current.component(.month, from: date)
        if let monthSymbols = DateFormatter().monthSymbols, monthSymbols.indices.contains(month) {
            if month > 0 {
                return "\(Calendar.current.component(.day, from: date)) " + monthSymbols[month - 1].capitalizingFirstLetter()

            }
        }
        return ""
    }

    private func getWeekDay(date: Date) -> String {
        let weekday = Calendar.current.component(.weekday, from: date)
        if let weekdaySymbols = DateFormatter().weekdaySymbols, weekdaySymbols.indices.contains(weekday) {
            if weekday > 0 {
                return weekdaySymbols[weekday - 1].capitalizingFirstLetter()
            }
        }
        return ""
    }
}

extension Date {
    static let yyyyMMddHHmmss: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    static let minuteAndSecondsFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm:ss"
        return formatter
    }()
    
    static let hourAndMinutesFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    static let hourMinutesSecondsFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }()
    
    static let dayMonthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        return formatter
    }()
    
    static let yearMonthDayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var minuteAndSeconds: String {
        return Date.minuteAndSecondsFormatter.string(from: self)
    }
    
    var hourAndMinutes: String {
        return Date.hourAndMinutesFormatter.string(from: self)
    }
    
    var dayMonthYear: String {
        return Date.dayMonthYearFormatter.string(from: self)
    }

    var yearMonthDay: String {
        return Date.yearMonthDayFormatter.string(from: self)
    }
}

extension TimeInterval {
    var minuteAndSeconds: String {
        let date = Date(timeIntervalSince1970: self)
        return date.minuteAndSeconds
    }
    
    var hourAndMinutes: String {
        let date = Date(timeIntervalSince1970: self)
        return date.hourAndMinutes
    }
    
    var dayMonthYear: String {
        let date = Date(timeIntervalSince1970: self)
        return date.dayMonthYear
    }
    
    var yearMonthDay: String {
        let date = Date(timeIntervalSince1970: self)
        return date.yearMonthDay
    }
}
