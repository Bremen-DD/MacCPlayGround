//
//  ContentView.swift
//  MacCPlayGround
//
//  Created by Noah's Ark on 2022/10/19.
//

import SwiftUI

struct ContentView: View {
    @State var text: String = ""
    @State var text2: String = ""
    @State var text3: String = ""
    @State var text4: String = ""
    
    var body: some View {
        VStack {
            ScheduleContainer(
                repeatedSchedule: ["월", "화", "수", "목", "금", "토", "일"],
                startTime: 9,
                startingMinute: 0,
                endTime: 17,
                finishingMinute: 30
            )

            StrokeButton(
                label: "근무지 삭제하기",
                buttonStyle: .destructive
            ) { }
            
            CustomTextField(
                textFieldType: .reason,
                keyboardType: .default,
                text: $text
            )
            .padding(.bottom)

            CustomTextFieldContainer(
                containerType: .workplace,
                keyboardType: .numberPad,
                text: $text2
            )
            .padding(.bottom)
            
            CustomTextFieldContainer(
                containerType: .wage,
                keyboardType: .numberPad,
                text: $text4
            )
            .padding(.bottom)
            
            CustomTextFieldContainer(
                containerType: .payday,
                keyboardType: .default,
                text: $text3
            )
            .padding(.bottom)
            
            CustomTextFieldContainer(
                containerType: .reason,
                keyboardType: .default,
                text: $text3
            )

        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
