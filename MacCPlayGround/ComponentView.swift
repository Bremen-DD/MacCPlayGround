//
//  ComponentView.swift
//  MacCPlayGround
//
//  Created by Noah's Ark on 2022/11/10.
//

import SwiftUI

struct ComponentView: View {
    @State var date = Date()
    
    var body: some View {
        VStack {
//            InputFormElement(containerType: .wage, text: .constant("1000"))
//            InputFormElement(containerType: .workplace, text: .constant("1000"))
            InputFormElement(containerType: .payday, text: .constant("25"))
            InputFormElement(containerType: .reason, text: .constant("1000"))
            InputFormElement(containerType: .none(title: "Title Here"), text: .constant("1000"))
            BorderedPicker(type: .date, date: $date)
        }
        .padding()
    }
}

struct ComponentView_Previews: PreviewProvider {
    static var previews: some View {
        ComponentView()
    }
}
