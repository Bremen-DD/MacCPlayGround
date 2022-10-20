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
    
    var body: some View {
        VStack {
            ScheduleContainer(
                workDays: ["월", "목", "토"],
                startingHour: 9,
                startingMinute: 0,
                finishingHour: 17,
                finishingMinute: 30
            )

            CompleteButton(
                title: "확인",
                isAvailable: true
            ) { }
            
            StrokeButton(
                title: "근무지 삭제하기",
                .destructive
            ) { }
            
            CustomTextField(
                placeholder: "근무지명을 입력해주세요",
                keyboardType: .default,
                text: $text
            )
            .padding(.bottom)
            
            CustomTextFieldContainer(
                containerType: .wage,
                placeholder: "9,160",
                keyboardType: .numberPad,
                text: $text2
            )
            .padding(.bottom)
            
            CustomTextFieldContainer(
                containerType: .payday,
                placeholder: "10",
                keyboardType: .numberPad,
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
