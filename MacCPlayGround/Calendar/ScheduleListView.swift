//
//  WeeklayCalendarLoadLogic.swift
//  MacCPlayGround
//
//  Created by Hyeon-sang Lee on 2022/11/08.
//
// 급여일 기준으로 보게 될텐데 월 단위 분리가 맞나?
// ✅ 강제 unwrapping 이 진행된 경우를 주석으로 표기했습니다.

import SwiftUI

struct ScheduleListView: View {
    @ObservedObject var viewModel = SchduleListViewModel()
    @State var selection = 1
    @State var isCreateButtonPressed = false
    @State var isMailboxButtonPressed = false
    let weekDays: [String] = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    var currentMonth: String {
        let components = Calendar.current.dateComponents([.year, .month], from: viewModel.currentDate)
        let year = components.year! // ✅
        let month = components.month! // ✅
        
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
    let mockData: [WorkspaceEntity] = [
        WorkspaceEntity(name: "팍이네 팍팍 감자탕", schedules: ScheduleEntity(), workdays: WorkdayEntity(endHour: 18)),
        WorkspaceEntity(name: "팍이네 팍팍 감자탕", schedules: ScheduleEntity(), workdays: WorkdayEntity(endHour: 15)),
        WorkspaceEntity(name: "팍이네 팍팍 감자탕", schedules: ScheduleEntity(), workdays: WorkdayEntity(endHour: 22)),
    ]
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                VStack {
                    header
                    scheduleContainer
                }
                .background(.gray)
                .toolbar(.hidden)
            }
        } else {
            NavigationView {
                VStack {
                    header
                    scheduleContainer
                }
                .background(.gray)
                .navigationBarHidden(true)
            }
        }
    }
}

private extension ScheduleListView {
    var header: some View {
        HStack(spacing: 0) {
            Group {
                Button {
                    viewModel.didTapPreviousMonth()
                } label: {
                    Image(systemName: "chevron.left")
                }
                Text(currentMonth)
                Button {
                    viewModel.didTapNextMonth()
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .font(.title)
            .foregroundColor(.black)
            Spacer()
            Button("메일함") { isMailboxButtonPressed.toggle() }
                .padding(.horizontal)
                .foregroundColor(.black)
            Button("추가") { isCreateButtonPressed.toggle() }
                .foregroundColor(.black)
            
            // NavigationLinks
            NavigationLink("", isActive: $isCreateButtonPressed) {
                ScheduleCreateView()
            }
            NavigationLink("", isActive: $isMailboxButtonPressed) {
                ScheduleUnreadListView()
            }
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
                Text(weekDays[index])
                    .font(.caption)
                    .frame(maxWidth: .infinity)
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    selection = 1
                    if newValue == 0 { viewModel.didScrollToPreviousWeek() }
                    if newValue == 2 { viewModel.didScrollToNextWeek() }
                }
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
                                viewModel.didTapDate(currentWeek[index].day)
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
                        VStack {
                            Text("\(currentWeek[index].day)")
                                .font(.callout)
                                .foregroundColor(.white)
                            Circle()
                                .frame(width: 6, height: 6)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(.blue)
                        .cornerRadius(15)
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
        ScrollView(showsIndicators: false) {
            VStack(spacing: 8) {
                ForEach(mockData) { data in
                    ScheduleCell(data: data)
                }
                Spacer()
            }
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
