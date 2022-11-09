//
//  ScheduleCell.swift
//  MacCPlayGround
//
//  Created by Noah's Ark on 2022/11/10.
//

import SwiftUI

struct ScheduleCell: View {
    let type: WorkType
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(type.title)
                    .font(.caption2)
                    .foregroundColor(.white)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 2)
                    .background(type.color)
                    .cornerRadius(5)
                Spacer()
                Text("4시간")
                    .font(.subheadline)
            }
            .padding(.bottom, 8)
            
            HStack {
                Text("GS 포항공대점")
                    .font(.body)
                Spacer()
                Text("10:00 ~ 14:00")

            }
            HStack {
                Spacer()
                Text("확정하기")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 29)
                    .padding(.vertical, 5)
                    .background(type.color)
                    .cornerRadius(10)
            }
            .padding(.vertical, 8)

        }
        .padding(.horizontal)
        .padding(.top, 19)
        .padding(.bottom, 8)
        .background(.gray)
        .cornerRadius(10)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.black, lineWidth: 2)
        }
    }
}

enum WorkType {
    case normal
    case short
    case long
    case plus
    
    var title: String {
        switch self {
        case .normal: return "정규"
        case .short: return "축소"
        case .long: return "연장"
        case .plus: return "추가"
        }
    }
    
    var color: Color {
        switch self {
        case .normal: return .green
        case .short: return .pink
        case .long: return .blue
        case .plus: return .purple
        }
    }
}
