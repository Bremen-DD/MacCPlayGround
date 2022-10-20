//
//  CustomTextField.swift
//  MacCPlayGround
//
//  Created by Noah's Ark on 2022/10/19.
//

import SwiftUI

struct CustomTextField: View {
    let placeholder: String
    let keyboardType: UIKeyboardType
    @Binding var text: String
    @State var isFocused: Bool = false
    
    var body: some View {
        customTextFieldView
    }
}

extension CustomTextField {
    var customTextFieldView: some View {
        VStack {
            UITextFieldRepresentable(
                text: $text,
                placeholder: placeholder,
                isFocused: $isFocused
            )
            .padding(.horizontal)
            .padding(.vertical, 9)
            .keyboardType(keyboardType)
            
            Rectangle()
                .frame(maxWidth: .infinity, minHeight: 2, maxHeight: 2)
                .foregroundColor(isFocused == false ? .gray : .green)
        }
        .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
    }
}

// https://medium.com/hcleedev/swift-textfield-기존-focus-방식과-새롭게-등장한-focusstate-활용하기-8725c7425140
struct UITextFieldRepresentable: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var isFirstResponder: Bool = false
    @Binding var isFocused: Bool
    
    func makeUIView(context: UIViewRepresentableContext<UITextFieldRepresentable>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.placeholder = self.placeholder
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<UITextFieldRepresentable>) {
        uiView.text = self.text
        if isFirstResponder && !context.coordinator.didFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.didFirstResponder = true
        }
    }
    
    func makeCoordinator() -> UITextFieldRepresentable.Coordinator {
        Coordinator(text: self.$text, isFocused: self.$isFocused)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        @Binding var isFocused: Bool
        var didFirstResponder = false
        
        init(text: Binding<String>, isFocused: Binding<Bool>) {
            self._text = text
            self._isFocused = isFocused
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            self.text = textField.text ?? ""
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            self.isFocused = true
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            self.isFocused = false
        }
    }
}
