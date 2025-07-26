//
//  ListItem.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 10.07.25.
//

import SwiftUI

struct CircularTimerView: View {
    let totalTime: Double = 30.0
    let startDate = Date()
    
    var body: some View {
        TimelineView(.animation) { context in
            let elapsed = context.date.timeIntervalSince1970
            let remaining = totalTime - (elapsed.truncatingRemainder(dividingBy: 30))
            let progress = remaining / totalTime
            
            let color = remaining < 5 ? Color.red : remaining < 10 ? .yellow : .blue
            
            ZStack {
                Text("\(Int(remaining))")
                    .font(.system(size: 10))
                    .tint(color)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(lineWidth: 2)
                    .foregroundColor(color)
            }
            .frame(width: 20, height: 20)
        }
    }
}

struct ListItemView: View {
    @State private var showingCopied = false
    
    let oneTimePassword: OneTimePassword
    let onClickCode: (String) -> Void
    
    init(item: OneTimePassword, onClickCode: @escaping (String) -> Void) {
        self.oneTimePassword = item
        self.onClickCode = onClickCode
    }
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(oneTimePassword.label)
                Text(oneTimePassword.account)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button(action: {
                withAnimation() {
                    showingCopied = true
                }
                onClickCode(oneTimePassword.generateTotp())
            }) {
                HStack {
                    CircularTimerView()
                    CodeView(oneTimePassword: oneTimePassword, showingCopied: $showingCopied)
                }
            }
        }
    }
}

#Preview {
    ListItemView(item: OneTimePassword(label: "Platform", issuer: "Issuer", account: "Account 1", secret: "a".data(using: .utf8)!, period: TimeInterval(30), digits: 6, algorithm: .sha1), onClickCode: { code in print("Hello World") })
}
