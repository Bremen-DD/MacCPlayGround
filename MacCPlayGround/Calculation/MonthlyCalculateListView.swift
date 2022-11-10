//
//  MonthlyCalculateListView.swift
//  MacCPlayGround
//
//  Created by Hyeon-sang Lee on 2022/11/10.
//

import SwiftUI

struct MonthlyCalculateListView: View {
    var body: some View {
        VStack(spacing: 0){
            header
            totalWageContainer
            workspaceList
        }
    }
}

private extension MonthlyCalculateListView {
    var header: some View {
        HStack(spacing: 0) {
            Text("정산")
            Spacer()
            // 컴포넌트로?
            Group {
                Button {
                } label: {
                    Image(systemName: "chevron.left")
                }
                Text("2022.11")
                Button {
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .font(.title)
            .foregroundColor(.black)

        }
    }
    
    var totalWageContainer: some View {
        HStack(spacing: 0) {
            Text("11월 총 금액")
            Spacer()
            Text("10,000,000원")
        }
    }
    
    var workspaceList: some View {
        Text("헬로")
    }
}
