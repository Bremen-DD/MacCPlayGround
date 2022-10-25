//
//  ScheduleContainer.swift
//  Rlog
//
//  Created by Noah's Ark on 2022/10/19.
//

import SwiftUI

struct ScheduleContainer: View {
    let repeatedSchedule: [String]
    let startHour: Int
    let startMinute: Int
    let endHour: Int
    let endMinute: Int
    
    var body: some View {
        scheduleContainerView
    }
}

private extension ScheduleContainer {
    var scheduleContainerView: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
            .foregroundColor(Color(UIColor.lightGray))
            .overlay { scheduleInformationView }
    }
    
    var scheduleInformationView: some View {
        HStack {
            repeatedScheduleView
            
            Spacer()
            
            workHourView
        }
        .padding()
    }
    
    var repeatedScheduleView: some View {
        HStack {
            ForEach(repeatedSchedule, id: \.self) { day in
                Text(day)
            }
        }
    }
    
    var workHourView: some View {
        HStack {
            // 시간이 n시 0분인 경우 두 자릿수인 00으로 표시
            if startMinute == 0 { Text("\(startHour):00") }
            else { Text("\(startHour):\(startMinute)") }
            
            Text("-")
            
            if endMinute == 0 { Text("\(endHour):00") }
            else { Text("\(endHour):\(endMinute)") }
        }
    }
}

//struct ScheduleContainer_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleContainer(
//            repeatedSchedule: ["월", "화", "수", "목", "금"],
//            startHour: 9,
//            startMinute: 30,
//            endHour: 18,
//            endMinute: 0
//        )
//    }
//}
