//
//  WeeklayCalendarLoadLogic.swift
//  MacCPlayGround
//
//  Created by Hyeon-sang Lee on 2022/11/08.
//
// 급여일 기준으로 보게 될텐데 월 단위 분리가 맞나?

import SwiftUI

struct WeeklyCalendarLoadLogic: View {
    @ObservedObject var viewModel = CalendarViewModel()
    @State var selection = 1
    let formatter = DateFormatter(dateFormatType: .weekday)
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
            header
            scheduleContainer
        }
        .background(.gray)
    }
}

private extension WeeklyCalendarLoadLogic {
    var header: some View {
        HStack(spacing: 0) {
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
                .padding(.horizontal)
                .foregroundColor(.black)
            Button("추가") { }
                .foregroundColor(.black)
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
    }
    
    var scheduleContainer: some View {
        VStack(spacing: 0) {
            Group {
                weekDaysContainer
                    .padding(.top)
                datesContainer
                    .padding(.bottom, 11)
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: 1.5)
            }
            .padding(.horizontal, 22)
            Spacer()
            scheduleList
                .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .cornerRadius(30, [.topLeft, .topRight])
        .padding(.top, 54)
        .ignoresSafeArea()
    }
    
    var weekDaysContainer: some View {
        HStack(spacing: 0) {
            ForEach(0..<7) { index in
                VStack {
                    if !viewModel.verifyCurrentMonth(currentWeek[index].month) {
                        Text("\(currentWeek[index].month)")
                            .font(.caption2)
                    } else {
                        Text("")
                            .font(.caption2)
                    }
                    Text(viewModel.weekDays[index])
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.top)
    }
    
    var datesContainer: some View {
        VStack(spacing: 0) {
            TabView(selection: $selection) {
                previousWeekdayBox.tag(0)
                weekdayBox.tag(1)
                nextWeekdayBox.tag(2)
            }
            .frame(height: 50)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: selection) { newValue in
                selection = 1

                if newValue == 0 { viewModel.getPreviousWeek() }
                if newValue == 2 { viewModel.getNextWeek() }

//                let result = viewModel.verifyCurrentWeek(currentWeek)
//                switch result {
//                case .past:
//                    isPast = true
//                case .current:
//                    isPast = false
//                    isFuture = false
//                case .future:
//                    isFuture = true
//                }
            }
        }
    }
    
    var weekdayBox: some View {
        HStack(spacing: 0) {
            ForEach(0..<7) { index in
                ZStack {
                    VStack {
                        Button {
                            withAnimation {
                                viewModel.changeFocusDate(currentWeek[index].day)
                            }
                        } label: {
                            Text("\(currentWeek[index].day)")
                                .font(.callout)
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .disabled(viewModel.verifyCurrentMonth(currentWeek[index].month) ? false : true)

                        Circle()
                            .frame(width: 6, height: 6)
                            .foregroundColor(.green)
                    }

                    if viewModel.verifyFocusDate(currentWeek[index].day) {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(.blue)
                            .overlay {
                                VStack {
                                    Text("\(currentWeek[index].day)")
                                        .font(.callout)
                                        .foregroundColor(.white)
                                    Circle()
                                        .frame(width: 6, height: 6)
                                        .foregroundColor(.white)
                                }
                            }
                    }
                }
            }
        }
    }
    
    var previousWeekdayBox: some View {
        HStack(spacing: 0) {
            ForEach(0..<7) { index in
                VStack {
                    Text("\(previousWeek[index].day)")
                        .frame(maxWidth: .infinity)
                    Circle()
                        .frame(width: 6, height: 6)
                        .foregroundColor(.green)
                }
            }
        }
    }

    var nextWeekdayBox: some View {
        HStack(spacing: 0) {
            ForEach(0..<7) { index in
                VStack {
                    Text("\(nextWeek[index].day)")
                        .frame(maxWidth: .infinity)
                    Circle()
                        .frame(width: 6, height: 6)
                        .foregroundColor(.green)
                }
            }
        }
    }
    
    var scheduleList: some View {
        VStack(spacing: 8) {
            ScheduleCell(type: .normal)
            ScheduleCell(type: .short)
            ScheduleCell(type: .long)
            ScheduleCell(type: .plus)
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
