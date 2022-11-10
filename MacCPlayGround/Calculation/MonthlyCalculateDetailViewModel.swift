//
//  MonthlyCalculateDetailViewModel.swift
//  MacCPlayGround
//
//  Created by Hyeon-sang Lee on 2022/11/10.
//

import Foundation

final class MonthlyCalculateDetailViewModel: ObservableObject {
    @Published var calculationPeriod: [Date] = []
    let paymentdDay = 25 // 정산일을 25일로 가정
    let calendar = Calendar.current
    
    func onAppear() {
        getAllDaysInDesignatedPeriod()
    }
}

extension MonthlyCalculateDetailViewModel {
    private func getAllDaysInDesignatedPeriod() {
        let today = calendar.dateComponents([.day], from: Date()).day! // ✅
        let timeDifference = paymentdDay - today
        
        // 현재 활성화된 날짜의 연, 월 데이터를 추출합니다.
        let currentComponents = calendar.dateComponents([.year, .month], from: Date())
        let year = currentComponents.year! // ✅
        let month = currentComponents.month! // ✅
                
        // 연, 월, 일 데이터를 사용하여 DateComponents를 생성합니다.
        let currentPoint = DateComponents(year: year, month: month, day: paymentdDay)
        let previousPoint = DateComponents(year: year, month: month - 1, day: paymentdDay)
        let paymentYearMonthDay = calendar.date(from: currentPoint)! // ✅
        let previousPaymentYearMonthDay = calendar.date(from: previousPoint)! // ✅

        switch timeDifference {
        case 0...: //25일, 25일 전
            let days = calendar
                .range(of: .day, in: .month, for: previousPaymentYearMonthDay)! // ✅
                .compactMap { calendar.date(byAdding: .day, value: $0, to: previousPaymentYearMonthDay) }
            calculationPeriod = days
            return
        case _ where timeDifference < 0: // 25일 이후
            let days = calendar
                .range(of: .day, in: .month, for: paymentYearMonthDay)! // ✅
                .compactMap { calendar.date(byAdding: .day, value: $0, to: paymentYearMonthDay) }
            calculationPeriod = days
            return
        default:
            return
        }
    }
}
