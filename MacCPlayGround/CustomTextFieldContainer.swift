//
//  CustomTextFieldContainer.swift
//  MacCPlayGround
//
//  Created by Noah's Ark on 2022/10/19.
//

import SwiftUI

enum ContainerType: String {
    case workplace = "근무지"
    case wage = "시급"
    case payday = "급여일"
}

struct CustomTextFieldContainer: View {
    let containerType: ContainerType
    let placeholder: String
    let keyboardType: UIKeyboardType
    var text: Binding<String>
    
    init(containerType: ContainerType, placeholder: String, keyboardType: UIKeyboardType, text: Binding<String>) {
        self.containerType = containerType
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.text = text
    }

    var body: some View {
        VStack {
            titleHeader
            container
        }
    }
}

extension CustomTextFieldContainer {
    var titleHeader: some View {
        HStack {
            Text(containerType.rawValue)
                .font(.caption)
                .foregroundColor(.gray)

            Spacer()
        }
    }
    
    @ViewBuilder var container: some View {
        switch containerType {
        case .workplace:
            workplaceView
        case .wage:
            wageView
        case .payday:
            paydayView
        }
    }
    
    var workplaceView: some View {
        CustomTextField(
            placeholder: placeholder,
            keyboardType: keyboardType,
            text: text
        )
    }

    var wageView: some View {
        HStack {
            CustomTextField(
                placeholder: placeholder,
                keyboardType: keyboardType,
                text: text
            )
            
            Spacer()
            
            Text("원")
        }
    }

    var paydayView: some View {
        HStack {
            Text("매월")
            Spacer()
            CustomTextField(
                placeholder: placeholder,
                keyboardType: keyboardType,
                text: text
            )
            Spacer()
            Text("일")
        }
    }
}
