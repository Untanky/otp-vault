//
//  ListItem.swift
//  OTPVault
//
//  Created by Lukas Grimm on 10.07.25.
//

import SwiftUI

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
                    .lineLimit(1)
                Text(oneTimePassword.account)
                    .lineLimit(1)
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
