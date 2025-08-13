//
//  CodeWithTimer.swift
//  iOS
//
//  Created by Lukas Grimm on 13.08.25.
//

import SwiftUI

struct CodeWithTimer: View {
    let oneTimePassword: OneTimePassword;
    
    @State private var showingCopied = false
    
    var body: some View {
        Button(action: {
            withAnimation {
                showingCopied = true
            }
            UIPasteboard.general.string = ""
        }) {
            HStack {
                CircularTimerView(totalTime: oneTimePassword.period)
                CodeView(oneTimePassword: oneTimePassword, showingCopied: $showingCopied)
            }
        }
    }
}

#Preview {
    CodeWithTimer(oneTimePassword: OneTimePassword(label: "", issuer: "", account: "", secret: "".data(using: .utf8)!, period: 30, digits: 6, algorithm: .sha1))
}
