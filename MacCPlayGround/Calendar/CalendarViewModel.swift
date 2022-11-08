//
//  CalendarViewModel.swift
//  MacCPlayGround
//
//  Created by Hyeon-sang Lee on 2022/11/08.
//


import Foundation

final class CalendarViewModel: ObservableObject {
    @Published var currentDate = Date()
    let calendar = Calendar.current
    
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

    func loadTheFirstDayOfWeek() -> [Int] {
        let today = calendar.startOfDay(for: currentDate)
        let dayOfWeek = calendar.component(.weekday, from: today)
        let days = calendar
            .range(of: .weekday, in: .weekOfYear, for: today)!
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
        let weekdayArray = days.map {
            let components = calendar.dateComponents([.year, .month, .day], from: $0)
            let day = components.day!
            
            return day
        }
        
        return weekdayArray
    }
    
    func resetWeekChanges() -> Date {
        let currentComponents = calendar.dateComponents([.year, .month], from: currentDate)
        let todayComponents = calendar.dateComponents([.day], from: Date())
        let year = currentComponents.year!
        let month = currentComponents.month!
        let day = todayComponents.day!
        let sampleDate = DateComponents(year: year, month: month, day: day)
        
        return calendar.date(from: sampleDate)!
    }
    
    func verifyFocusDate(_ focusDate: Int) -> Bool {
        let components = Calendar.current.dateComponents([.day], from: Date())
        let date = components.day!
        
        if focusDate == date { return true }
        else { return false }
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
