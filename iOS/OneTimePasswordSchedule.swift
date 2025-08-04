//
//  OneTimePasswordSchedule.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 26.07.25.
//

import SwiftUI

struct OneTimePasswordSchedule: TimelineSchedule {
    let period: TimeInterval

    init(period: TimeInterval) {
        self.period = period
    }

    func entries(from startDate: Date, mode: TimelineScheduleMode) -> AnyIterator<Date> {
        let calendar = Calendar.current
        let nextPeriod = ceil(startDate.timeIntervalSince1970 / period)
        var lastUpdate = Date(timeIntervalSince1970: nextPeriod * period)

        return AnyIterator {
            defer {
                lastUpdate = calendar.date(byAdding: .second, value: Int(period), to: lastUpdate) ?? lastUpdate
            }
            return lastUpdate
        }
    }
}
