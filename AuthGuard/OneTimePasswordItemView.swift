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
    let onClickCode: (String) -> Void
    
    @State private var code: String
    
    init(item: OneTimePasswordItem, onClickCode: @escaping (String) -> Void) {
        self.title = item.title
        self.account = item.account
        self.secret = item.secret
        self.onClickCode = onClickCode
        
        self.code = generateHotp(secret, 1)
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
    }
}

#Preview {
    OneTimePasswordItemView(item: OneTimePasswordItem(title: "Platform", account: "Account 1", secret: "a".data(using: .utf8)!), onClickCode: { code in print("Hello World") })
}
