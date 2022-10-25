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
            RoundedRectangle(cornerRadius: 50)
                .stroke(.black, lineWidth: 10)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
