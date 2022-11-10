//
//  MonthlyCalculateDetailView.swift
//  MacCPlayGround
//
//  Created by Hyeon-sang Lee on 2022/11/10.
//
//  ✅ 급여일을 25일로 가정

import SwiftUI

struct MonthlyCalculateDetailView: View {
    @ObservedObject var viewModel = MonthlyCalculateDetailViewModel()
    var monthStructure: [[Date]] {
        return viewModel.calculationPeriod.chunked(into: 7)
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            workspaceInfo
            calculationDetail
            scheduleCalendar
            workDetails
            Spacer()
        }
        .onAppear { viewModel.onAppear()
            print(monthStructure)
        }
    }
}

private extension MonthlyCalculateDetailView {
    var workspaceInfo: some View {
        VStack(spacing: 0) {
            Text("GS25 포항공대점")
            Text("2022년 10월 25일 ~ 2022년 11월 24일")
            Text("정산일까지 D-12")
        }
    }

    var calculationDetail: some View {
        VStack(spacing: 0) {
            HStack {
                Text("결산")
                Spacer()
            }
            HStack {
                Text("일한 시간")
                Spacer()
                Text("32시간")
            }
            HStack {
                Text("시급")
                Spacer()
                Text("11,000원")
            }
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundColor(.gray)
            HStack {
                Spacer()
                Text("352,000원")
            }
            HStack {
                Text("주휴수당 적용됨")
                Spacer()
                Text("70,400원")
            }
            HStack {
                Text("소득세 3.3% 적용")
                Spacer()
                Text("13,939원")
            }
            HStack {
                Text("총 급여")
                Spacer()
                Text("422,400원")
            }
        }
    }

    var scheduleCalendar: some View {
        VStack(spacing: 0) {
            HStack {
                Text("근무표")
                Spacer()
            }
            ForEach(monthStructure, id: \.self) { data in
                VStack {
                    HStack {
                        ForEach(data, id: \.self) { date in
                            let day = Calendar.current.dateComponents([.day], from: date).day!
                            Text("\(day)")
                        }
                        .frame(maxWidth: .infinity)
                        Spacer()
                    }
                }

//                ForEach(0..<6) { row in
//                    HStack(spacing: 1) {
//                        ForEach(1..<8) { column in
//                    }
//                }
            }
        }
    }
    
    var workDetails: some View {
        VStack(spacing: 0) {
            Text("상세정보")
            Group {
                RoundedRectangle(cornerRadius: 10)
                RoundedRectangle(cornerRadius: 10)
                RoundedRectangle(cornerRadius: 10)
            }
            .frame(width: 300, height: 100)
            .foregroundColor(.gray)
            .padding(.bottom, 10)
        }
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
