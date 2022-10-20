//
//  ScheduleContainer.swift
//  MacCPlayGround
//
//  Created by Noah's Ark on 2022/10/19.
//

import SwiftUI

struct ScheduleContainer: View {
    let workDays: [String]
    let startingHour: Int
    let startingMinute: Int
    let finishingHour: Int
    let finishingMinute: Int
    
    var body: some View {
        scheduleContainerView
    }
}

extension ScheduleContainer {
    var scheduleContainerView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
                .foregroundColor(Color(UIColor.lightGray))

            scheduleContainerLabelView
                .padding()
        }
    }
    
    var scheduleContainerLabelView: some View {
        HStack {
            workDayView
            Spacer()
            workHourView
        }
    }
    
    var workDayView: some View {
        HStack {
            ForEach(workDays, id: \.self) { day in
                Text(day)
            }
        }
    }
    
    var workHourView: some View {
        HStack {
            if startingMinute == 0 {
                Text("\(startingHour):00")
            } else {
                Text("\(startingHour):\(startingMinute)")
            }
            Text("-")
            if finishingMinute == 0 {
                Text("\(finishingHour):00")
            } else {
                Text("\(finishingHour):\(finishingMinute)")
            }
        }
    }
}

struct ScheduleContainer_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleContainer(
            workDays: ["월", "화", "수", "목", "금"],
            startingHour: 9,
            startingMinute: 30,
            finishingHour: 18,
            finishingMinute: 0
        )
    }
}
