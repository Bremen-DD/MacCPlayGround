//
//  CalendarViewModel.swift
//  MacCPlayGround
//
//  Created by Hyeon-sang Lee on 2022/11/08.
//
// ✅ 강제 unwrapping 이 진행된 경우를 주석으로 표기했습니다.

import Foundation
import SwiftUI

final class SchduleListViewModel: ObservableObject {
    let calendar = Calendar.current
    @Published var nextDate = Calendar.current.date(byAdding: .weekOfMonth, value: 1, to: Date())! // ✅
    @Published var previousDate = Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: Date())! // ✅
    @Published var currentDate = Date() {
        didSet {
            guard let nextWeek = Calendar.current.date(byAdding: .weekOfMonth, value: 1, to: currentDate)
            else { return }
            guard let previousWeek = Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: currentDate)
            else { return }
            nextDate = nextWeek
            previousDate = previousWeek
        }
    }
    
    func didScrollToNextWeek() {
        getNextWeek()
    }
    
    func didScrollToPreviousWeek() {
        getPreviousWeek()
    }
    
    func didTapNextMonth() {
        getNextMonth()
    }
    
    func didTapPreviousMonth() {
        getPreviousMonth()
    }
    
    func didTapDate(_ date: Int) {
        changeFocusDate(date)
    }
}

extension SchduleListViewModel {
    // 일주일 뒤의 날짜를 반환합니다.
    private func getNextWeek() {
        guard let dateOfNextWeek = calendar.date(byAdding: .weekOfMonth, value: 1, to: currentDate)
        else { return }
        currentDate = dateOfNextWeek
    }

    // 일주일 전의 날짜를 반환합니다.
    private func getPreviousWeek() {
        guard let dateOfPreviousWeek = calendar.date(byAdding: .weekOfMonth, value: -1, to: currentDate)
        else { return }
        currentDate = dateOfPreviousWeek
    }
    
    // 사용자가 getNextWeek, getPreviousWeek 함수를 통해 주 단위 변경을 진행한 경우를 초기화합니다.
    private func resetWeekChanges() -> Date {
        // 현재 활성화된 날짜의 연, 월 데이터를 추출합니다.
        let currentComponents = calendar.dateComponents([.year, .month], from: currentDate)
        let year = currentComponents.year! // ✅
        let month = currentComponents.month! // ✅
        
        // 오늘 날짜의 일 데이터를 추출합니다.
        let todayComponents = calendar.dateComponents([.day], from: Date())
        let day = todayComponents.day! // ✅
        
        // 연, 월, 일 데이터를 사용하여 DateComponents를 생성합니다.
        let sampleDate = DateComponents(year: year, month: month, day: day)
        
        return calendar.date(from: sampleDate)! // ✅
    }
    
    // 한 달 뒤의 날짜를 반환합니다.
    // 갱신 이후 한 달 전의 오늘 날짜로 포커싱 됩니다. (ex. 11월 9일 -> 12월 9일)
    private func getNextMonth() {
        let resetWeeks = resetWeekChanges()
        guard let dateOfNextMonth = calendar.date(byAdding: .month, value: 1, to: resetWeeks) else { return }
        currentDate = dateOfNextMonth
    }

    // 한 달 전의 날짜를 반환합니다.
    // 갱신 이후 한 달 전의 오늘 날짜로 포커싱 됩니다. (ex. 11월 9일 -> 10월 9일)
    private func getPreviousMonth() {
        let resetWeeks = resetWeekChanges()
        guard let dateOfPreviousMonth = calendar.date(byAdding: .month, value: -1, to: resetWeeks) else { return }
        currentDate = dateOfPreviousMonth
    }
    
    // 사용자가 다른 날짜를 터치했을 때 Focus를 변경합니다.
    private func changeFocusDate(_ date: Int) {
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        let year = components.year! // ✅
        let month = components.month! // ✅
        let focusDateComponents = DateComponents(year: year, month: month, day: date)
        let focusDate = calendar.date(from: focusDateComponents)!
        
        currentDate = focusDate
    }
    
    // 오늘 날짜가 속한 주의 날짜 데이터를 반환합니다.
    // https://stackoverflow.com/questions/42981665/how-to-get-all-days-in-current-week-in-swift
    func loadTheFirstDayOfWeek(_ date: Date) -> [CalendarModel] {
        let today = calendar.startOfDay(for: date)
        let dayOfWeek = calendar.component(.weekday, from: today)
        
        // .range: 1..<8 을 반환합니다. 1 = 일요일, 7 = 토요일
        // .compactMap: 각 range의 값에서 오늘의 요일 만큼 차감한 값을 today에 적용합니다. nil의 경우는 제외합니다.
        // ex
        //  1  2  3 4 5 6 7 (range)
        // -3 -2 -1 0 1 2 3 (today가 수요일인 경우를 적용, 4 = 수요일)
        //  [3일 전, 2일 전, 1일 전, 오늘, 1일 후, 2일 후, 3일 후] (반환값)
        let days = calendar
            .range(of: .weekday, in: .weekOfYear, for: today)! // ✅
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
        
        // 반환된 배열의 날짜 데이터를 각각 추출합니다.
        // UI 작업을 위해 임시로 사용합니다.
        let weekdayArray = days.map {
            let components = calendar.dateComponents([.year, .month, .day], from: $0)
            let year = components.year! // ✅
            let month = components.month! // ✅
            let day = components.day! // ✅
            
            return CalendarModel(year: year, month: month, day: day)
        }
        
        return weekdayArray
    }
    
    // 터치된 날짜를 판단합니다.
    func verifyFocusDate(_ focusDate: Int) -> Bool {
        let components = calendar.dateComponents([.day], from: currentDate)
        let date = components.day! // ✅
        
        if focusDate == date { return true }
        else { return false }
    }
    
    // 터치된 날짜의 월 데이터를 판단합니다.
    func verifyCurrentMonth(_ date: Int) -> Bool {
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        if date == components.month! { return true } // ✅
        return false
    }
}

// MARK: ScheduleCell
extension SchduleListViewModel {
    // 🔥 필요한 것만 받기 -> 파라미터 너무 많음
    // 🔥 WorkspaceEntity 하나 받기 -> 간단함 but over-fetching
    func defineWorkType(repeatDays: [String], workDate: Date, startHour: Int16, startMinute: Int16, endHour: Int16, endMinute: Int16, spentHour: Int16) -> (type: String, color: Color) {
        let formatter = DateFormatter(dateFormatType: .weekday)
        let _ = formatter.string(from: workDate)
        let spentHourOfNormalCase: Int16 = endHour - startHour
        let timeDifference = spentHour - spentHourOfNormalCase
        
        print(timeDifference)
        
//        for day in repeatDays {
//            if day != weekday { return ("추가", .blue) }
//        }

        switch timeDifference {
        case 0:
            return ("정규", .green)
        case 1...:
            return ("연장", .orange)
        case _ where timeDifference < 0:
            return ("축소", .pink)
        default:
            return ("정규", .green)
        }
    }
}

// .dayInt인 경우, 일요일을 시작으로 1, 2, 3 ... 순으로 표기됩니다.
// .weekday인 경우, 일요일을 시작으로 일, 월, 화 ... 순으로 표기됩니다.
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
