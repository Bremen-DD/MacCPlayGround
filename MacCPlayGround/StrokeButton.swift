//
//  StrokeButton.swift
//  MacCPlayGround
//
//  Created by Noah's Ark on 2022/10/19.
//

import SwiftUI

enum ButtonStyle {
    case add
    case destructive
}

struct StrokeButton: View {
    let title: String
    let buttonStyle: ButtonStyle
    let action: () -> Void

    init(title: String, _ buttonStyle: ButtonStyle, action: @escaping () -> Void) {
        self.title = title
        self.buttonStyle = buttonStyle
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            strokeButtonContainerView
        }
    }
}

extension StrokeButton {
    var strokeButtonContainerView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(buttonStyle == .add ? .gray : .red, lineWidth: 1)
                .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)

            Text(title)
                .foregroundColor(buttonStyle == .add ? .gray : .red)
        }
    }
}

struct StrokeButton_Previews: PreviewProvider {
    static var previews: some View {
        StrokeButton(title: "+ 근무 추가하기", .destructive) { }
    }
}
