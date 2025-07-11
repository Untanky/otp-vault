//
//  OneTimePasswordItem.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 10.07.25.
//

import SwiftUI

struct OneTimePasswordItemView: View {
    private static let codeFont = Font.system(size: 24, weight: .bold, design: .monospaced)
    
    let title: String
    let account: String
    let secret: Data
    let interval: TimeInterval
    
    let onClickCode: (String) -> Void
    
    @State var timerId: TimerId?
    
    @State private var code: String
    
    init(item: OneTimePasswordItem, onClickCode: @escaping (String) -> Void) {
        self.title = item.title
        self.account = item.account
        self.secret = item.secret
        self.interval = item.interval
        
        self.onClickCode = onClickCode
        
        self.code = generateHotp(secret, Int(Date().timeIntervalSince1970))
    }
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(title)
                Text(account)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button(action: { onClickCode(String(code)) }) {
                Text(code)
                    .font(OneTimePasswordItemView.codeFont)
            }
        }
        .onAppear {
            self.timerId = TimerService.shared.register(forInterval: interval, callback: {
                self.code = generateHotp(secret, Int(Date().timeIntervalSince1970))
            })
        }
        .onDisappear {
            guard let timerId else { return }
            TimerService.shared.unregister(id: timerId)
            self.timerId = nil
        }
    }
}

#Preview {
    OneTimePasswordItemView(item: OneTimePasswordItem(title: "Platform", account: "Account 1", secret: "a".data(using: .utf8)!, interval: TimeInterval(30)), onClickCode: { code in print("Hello World") })
}
