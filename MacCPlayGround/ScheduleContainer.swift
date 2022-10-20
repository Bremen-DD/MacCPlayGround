//
//  ScheduleContainer.swift
//  MacCPlayGround
//
//  Created by Noah's Ark on 2022/10/19.
//

import SwiftUI

/*
 repeatedSchedule: [String]
 startTime: String
 endTime: String
 spentHour: Int

 workspace: Workspace
 */

struct ScheduleContainer: View {
    let repeatedSchedule: [String]
    let startTime: Int
    let startingMinute: Int
    let endTime: Int
    let finishingMinute: Int
    var spentTime: Int {
        endTime - startTime
    }
    
    var body: some View {
        scheduleContainerView
    }
}

private extension ScheduleContainer {
    var scheduleContainerView: some View {
        // iOS 14.0 does not support .overlay method
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
                .foregroundColor(Color(UIColor.lightGray))

            HStack {
                repeatedScheduleView
                
                Spacer()
                
                workHourView
            }
            .padding()
        }
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
            if startingMinute == 0 { Text("\(startTime):00") }
            else { Text("\(startTime):\(startingMinute)") }

            Text("-")
            
            if finishingMinute == 0 { Text("\(endTime):00") }
            else { Text("\(endTime):\(finishingMinute)") }
        }
    }
}

//struct ScheduleContainer_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleContainer(
//            repeatedSchedule: ["월", "화", "수", "목", "금"],
//            startTime: 9,
//            startingMinute: 30,
//            endTime: 18,
//            finishingMinute: 0
//        )
//    }
//}
