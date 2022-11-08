//
//  WeeklayCalendarLoadLogic.swift
//  MacCPlayGround
//
//  Created by Hyeon-sang Lee on 2022/11/08.
//

import SwiftUI

struct WeeklyCalendarLoadLogic: View {
    @ObservedObject var viewModel = CalendarViewModel()
    @State var selection = 1
    let weekDays: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    var currentMonth: String {
        let components = Calendar.current.dateComponents([.year, .month], from: viewModel.currentDate)
        let year = components.year!
        let month = components.month!
        
        return "\(year). \(month)"
    }
    var currentWeek: [Int] {
        return viewModel.loadTheFirstDayOfWeek()
    }
    var body: some View {
        buttonMonthSection
            .padding(.bottom)
        weekDaysContainer
        datesContainer
            .padding(.bottom)
        buttonWeekSection
    }
}

private extension WeeklyCalendarLoadLogic {
    var buttonMonthSection: some View {
        HStack {
            Button("<") { viewModel.getPreviousMonth() }
            Text(currentMonth)
            Button(">") { viewModel.getNextMonth() }
        }
        
    }
    var buttonWeekSection: some View {
        HStack {
            Button("<") { viewModel.getPreviousWeek() }
            Text("한 주씩 옮기기 ㅡㅡ")
            Button(">") { viewModel.getNextWeek() }
        }
    }
    
    var weekDaysContainer: some View {
        HStack {
            ForEach(weekDays, id: \.self) { day in
                Text(day)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    var datesContainer: some View {
        VStack {
            TabView(selection: $selection) {
                weekdayBox
                    .tag(0)
                weekdayBox
                    .tag(1)
                weekdayBox
                    .tag(2)
            }
            .frame(height: 50)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: selection) { newValue in
                if newValue == 2 { viewModel.getNextWeek() }
                if newValue == 0 { viewModel.getPreviousWeek() }
                selection = 1
                
            }
        }
    }
    
    var weekdayBox: some View {
        HStack {
            ForEach(currentWeek, id: \.self) { weekday in
                Text("\(weekday)")
                    .foregroundColor(viewModel.verifyFocusDate(weekday) ? .red : .black)
            }
        }
    }
    
}




//dateManager.date

//CalendarCell(
//    startingPosition: startingPosition,
//    totalDaysInMonth: totalDaysInMonth,
//    totalDaysInPreviousMonth: totalDaysInPreviousMonth
//)

//if let totalDaysInMonth = totalDaysInMonth,
//   let startingPosition = startingPosition,
//   let totalDaysInPreviousMonth = totalDaysInPreviousMonth {
//
//    Text("1")
//}
