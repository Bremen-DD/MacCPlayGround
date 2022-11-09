//
//  CalendarViewModel.swift
//  MacCPlayGround
//
//  Created by Hyeon-sang Lee on 2022/11/08.
//

import Foundation
import SwiftUI

final class CalendarViewModel: ObservableObject {
    let calendar = Calendar.current
    // !!!
    @Published var nextDate = Calendar.current.date(byAdding: .weekOfMonth, value: 1, to: Date())!
    // !!!
    @Published var previousDate = Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: Date())!
    @Published var currentDate = Date() {
        didSet {
            guard let nextWeek = Calendar.current.date(byAdding: .weekOfMonth, value: 1, to: currentDate) else { return }
            guard let previousWeek = Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: currentDate) else { return }
            nextDate = nextWeek
            previousDate = previousWeek
        }
    }

    
    func getNextMonth() {
        let resetWeeks = resetWeekChanges()
        guard let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: resetWeeks) else { return }
        self.currentDate = nextMonth
    }

    func getPreviousMonth() {
        let resetWeeks = resetWeekChanges()
        guard let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: resetWeeks) else { return }
        self.currentDate = previousMonth
    }
    
    func getNextWeek() {
        guard let nextWeek = Calendar.current.date(byAdding: .weekOfMonth, value: 1, to: currentDate) else { return }
        self.currentDate = nextWeek
    }

    func getPreviousWeek() {
        guard let previousWeek = Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: currentDate) else { return }
        self.currentDate = previousWeek
    }

    func loadTheFirstDayOfWeek(_ date: Date) -> [CalendarModel] {
        let today = calendar.startOfDay(for: date)
        let dayOfWeek = calendar.component(.weekday, from: today)
        let days = calendar
            .range(of: .weekday, in: .weekOfYear, for: today)!
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
        let weekdayArray = days.map {
            let components = calendar.dateComponents([.year, .month, .day], from: $0)
            let year = components.year!
            let month = components.month!
            let day = components.day!
            
            return CalendarModel(year: year, month: month, day: day)
        }
        
        return weekdayArray
    }
    
    func resetWeekChanges() -> Date {
        let currentComponents = calendar.dateComponents([.year, .month], from: currentDate)
        let todayComponents = calendar.dateComponents([.day], from: Date())
        // !!!
        let year = currentComponents.year!
        // !!!
        let month = currentComponents.month!
        let day = todayComponents.day!
        let sampleDate = DateComponents(year: year, month: month, day: day)
        
        // !!!
        return calendar.date(from: sampleDate)!
    }
    
    func verifyFocusDate(_ focusDate: Int) -> Bool {
        let components = Calendar.current.dateComponents([.day], from: currentDate)
        // !!!
        let date = components.day!
        
        if focusDate == date { return true }
        else { return false }
    }
    
    func verifyCurrentMonth(_ date: Int) -> Color {
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        // !!!
        if date == components.month! { return .black }
        return .gray
    }
    
    func changeFocusDate(_ date: Int) {
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        let year = components.year!
        let month = components.month!
        let focusDateComponents = DateComponents(year: year, month: month, day: date)
        let focusDate = calendar.date(from: focusDateComponents)!
        
        currentDate = focusDate
    }
    
}

extension DateFormatter {
    enum DateFormatType {
        case dayInt
        case weekday
        
        var dateFormat: String {
            switch self {
            case .dayInt: return "d"
            case .weekday: return "E"
            }
        }
    }
    
    convenience init(dateFormatType: DateFormatType) {
        self.init()
        self.dateFormat = dateFormatType.dateFormat
    }
}

struct CalendarModel {
    let year: Int
    let month: Int
    let day: Int
}
