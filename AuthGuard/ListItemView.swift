//
//  ListItem.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 10.07.25.
//

import SwiftUI

struct ListItemView: View {
    private static let codeFont = Font.system(size: 24, weight: .bold, design: .monospaced)
    
    let oneTimePassword: OneTimePassword
    
    let onClickCode: (String) -> Void
    
    @State var timerId: TimerId?
    
    @State private var code: String
    
    init(item: OneTimePassword, onClickCode: @escaping (String) -> Void) {
        self.oneTimePassword = item
        
        self.onClickCode = onClickCode
        
        self.code = item.generateTotp()
    }
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(oneTimePassword.label)
                Text(oneTimePassword.account)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button(action: { onClickCode(String(code)) }) {
                Text(code)
                    .font(ListItemView.codeFont)
            }
        }
        .onAppear {
            self.timerId = TimerService.shared.register(forInterval: oneTimePassword.period, callback: {
                self.code = oneTimePassword.generateTotp()
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
    ListItemView(item: OneTimePassword(label: "Platform", issuer: "Issuer", account: "Account 1", secret: "a".data(using: .utf8)!, period: TimeInterval(30), digits: 6, algorithm: .sha1), onClickCode: { code in print("Hello World") })
}
