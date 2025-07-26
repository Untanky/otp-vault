//
//  CodeView.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 25.07.25.
//

import SwiftUI

// Custom TimelineSchedule for periodic updates
struct OneTimePasswordSchedule: TimelineSchedule {
    /// The interval at which the timeline should update (e.g., 1 second).
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

struct CodeView: View {
    private static let codeFont = Font.system(size: 24, weight: .bold, design: .monospaced)
    
    let oneTimePassword: OneTimePassword
    
    @State private var code: String
    
    init(oneTimePassword: OneTimePassword) {
        self.oneTimePassword = oneTimePassword
        self.code = oneTimePassword.generateTotp()
    }
    
    var body: some View {
        TimelineView(OneTimePasswordSchedule(period: oneTimePassword.period)) { context in
            ZStack {
                Text(code)
                    .font(CodeView.codeFont)
                    .tint(.blue)
                    .id(code)
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .scale(scale: 0, anchor: .bottom)),
                            removal: .move(edge: .top).combined(with: .scale(scale: 0, anchor: .top))
                        )
                    )
            }
            .onChange(of: context.date) { _, _ in
                withAnimation {
                    code = oneTimePassword.generateTotp()
                }
            }
        }
    }
}

#Preview {
    CodeView(oneTimePassword: .init(label: "Test", issuer: "Test", account: "Test", secret: "Hello World".data(using: .utf8)!, period: 10, digits: 6, algorithm: .sha1))
}
