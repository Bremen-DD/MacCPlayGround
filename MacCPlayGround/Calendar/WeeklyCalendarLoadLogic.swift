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
    let mockData: [MockData] = [
        MockData(workspace: "팍이네 팍팍 감자탕", workDay: "월"),
        MockData(workspace: "팍이네 팍팍 감자탕", workDay: "화"),
        MockData(workspace: "팍이네 팍팍 감자탕", workDay: "수"),
        MockData(workspace: "팍이네 팍팍 감자탕", workDay: "목"),
        MockData(workspace: "팍이네 팍팍 감자탕", workDay: "금")
    ]
    let formatter = DateFormatter(dateFormatType: .weekday)
    
    var body: some View {
        buttonMonthSection
        scheduleContainer
        Spacer()
    }
}

private extension WeeklyCalendarLoadLogic {
    var buttonMonthSection: some View {
        HStack {
            Button("<") { viewModel.getPreviousMonth() }
            Text(currentMonth)
            Button(">") { viewModel.getNextMonth() }
            Spacer()
            Button("메일함") { }
            Button("추가") { }
        }
        .padding()
    }
    
    var scheduleContainer: some View {
        VStack {
            weekDaysContainer
            datesContainer
            Spacer()
            scheduleList
        }
        .frame(maxHeight: .infinity)
        .background(.gray)
        .ignoresSafeArea()
        .cornerRadius(10, [.topLeft, .topRight])
        
    }
    
    var weekDaysContainer: some View {
        HStack {
            ForEach(weekDays, id: \.self) { day in
                Text(day)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.top)
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
                    .frame(maxWidth: .infinity)
                    .foregroundColor(viewModel.verifyFocusDate(weekday) ? .red : .black)
            }
        }
    }
    
    var scheduleList: some View {
        VStack {
            ForEach(mockData, id: \.self) { data in
                if data.workDay == formatter.string(from: viewModel.currentDate) {
                    HStack {
                        Text(data.workspace)
                        Text(data.workDay)
                            .font(.title)
                    }
                    .background(.white)
                }
            }
            Spacer()
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, _ corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
