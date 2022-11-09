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
    let weekDays: [String] = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    let formatter = DateFormatter(dateFormatType: .weekday)
    let mockData: [MockData] = [
        MockData(workspace: "팍이네 팍팍 감자탕", workDay: "월"),
        MockData(workspace: "팍이네 팍팍 감자탕", workDay: "화"),
        MockData(workspace: "팍이네 팍팍 감자탕", workDay: "수"),
        MockData(workspace: "팍이네 팍팍 감자탕", workDay: "목"),
        MockData(workspace: "팍이네 팍팍 감자탕", workDay: "금")
    ]
    var currentMonth: String {
        let components = Calendar.current.dateComponents([.year, .month], from: viewModel.currentDate)
        let year = components.year!
        let month = components.month!
        
        return "\(year). \(month)"
    }
    var currentWeek: [CalendarModel] {
        return viewModel.loadTheFirstDayOfWeek(viewModel.currentDate)
    }
    var previousWeek: [CalendarModel] {
        return viewModel.loadTheFirstDayOfWeek(viewModel.previousDate)
    }
    var nextWeek: [CalendarModel] {
        return viewModel.loadTheFirstDayOfWeek(viewModel.nextDate)
    }

    var body: some View {
        VStack {
            buttonMonthSection
            scheduleContainer
            Spacer()
        }
        .background(.gray)
    }
}

private extension WeeklyCalendarLoadLogic {
    var buttonMonthSection: some View {
        HStack {
            Group {
                Button {
                    viewModel.getPreviousMonth()
                } label: {
                    Image(systemName: "chevron.left")
                }
                Text(currentMonth)
                Button {
                    viewModel.getNextMonth()
                } label: {
                    Image(systemName: "chevron.right")
                }

            }
            .font(.title)
            .foregroundColor(.black)
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .cornerRadius(30, [.topLeft, .topRight])
    }
    
    var weekDaysContainer: some View {
        HStack {
            ForEach(0..<7) { index in
                Text(weekDays[index])
                    .frame(maxWidth: .infinity)
                    .foregroundColor(viewModel.verifyCurrentMonth(currentWeek[index].month))
            }
        }
        .padding(.top)
    }
    
    var datesContainer: some View {
        VStack {
            TabView(selection: $selection) {
                previousWeekdayBox
                    .tag(0)
                weekdayBox
                    .tag(1)
                nextWeekdayBox
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
            ForEach(0..<7) { index in
                Button("\(currentWeek[index].day)") {
                    viewModel.changeFocusDate(currentWeek[index].day)
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(
                    viewModel.verifyFocusDate(currentWeek[index].day)
                    ? .red
                    : viewModel.verifyCurrentMonth(currentWeek[index].month)
                )
                .disabled(viewModel.verifyCurrentMonth(currentWeek[index].month) == .black ? false : true)
            }
        }
    }
    
    var previousWeekdayBox: some View {
        HStack {
            ForEach(0..<7) { index in
                Text("\(previousWeek[index].day)")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(
                        viewModel.verifyFocusDate(previousWeek[index].day)
                        ? .red
                        : viewModel.verifyCurrentMonth(previousWeek[index].month)
                    )
            }
        }
    }

    var nextWeekdayBox: some View {
        HStack {
            ForEach(0..<7) { index in
                Text("\(nextWeek[index].day)")
                    .frame(maxWidth: .infinity)
                    .foregroundColor(
                        viewModel.verifyFocusDate(nextWeek[index].day)
                        ? .red
                        : viewModel.verifyCurrentMonth(nextWeek[index].month)
                    )
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

struct MockData: Hashable {
    let workspace: String
    let workDay: String
}
