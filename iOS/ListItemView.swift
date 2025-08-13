//
//  ListItem.swift
//  OTPVault
//
//  Created by Lukas Grimm on 10.07.25.
//

import SwiftUI

struct ListItemView: View {
    @State private var showingCopied = false
    
    private let oneTimePassword: OneTimePassword
    
    init(item: OneTimePassword) {
        self.oneTimePassword = item
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
            CodeWithTimer(oneTimePassword: oneTimePassword)
        }
    }
}

#Preview {
    ListItemView(item: OneTimePassword(label: "Platform", issuer: "Issuer", account: "Account 1", secret: "a".data(using: .utf8)!, period: TimeInterval(30), digits: 6, algorithm: .sha1))
}
