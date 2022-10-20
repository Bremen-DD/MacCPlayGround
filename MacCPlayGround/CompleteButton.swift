//
//  CompleteButton.swift
//  MacCPlayGround
//
//  Created by Noah's Ark on 2022/10/19.
//

import SwiftUI

struct CompleteButton: View {
    let title: String
    var isAvailable: Bool
    let action: () -> Void
    
    init(title: String, isAvailable: Bool, action: @escaping () -> Void) {
        self.title = title
        self.isAvailable = isAvailable
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            compleButtonContainerView
        }
        .disabled(!isAvailable)
    }
}

extension CompleteButton {
    var compleButtonContainerView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
                .foregroundColor(isAvailable ? .green : .gray)

            completeButtonLabelView
        }
    }
    
    var completeButtonLabelView: some View {
        Text("확인")
            .font(.body)
            .foregroundColor(.white)
            .fontWeight(isAvailable ? .none : .bold)
    }
}

struct CompleteButton_Previews: PreviewProvider {
    static var previews: some View {
        CompleteButton(title: "확인", isAvailable: true) { }
    }
}
