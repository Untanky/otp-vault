//
//  CodeView.swift
//  OTPVault
//
//  Created by Lukas Grimm on 25.07.25.
//

import SwiftUI

struct CodeView: View {
    private static let codeFont = Font.system(size: 24, weight: .bold, design: .monospaced)
    private static let resetCopyDelay: TimeInterval = 2
    
    private let oneTimePassword: OneTimePassword
    
    @State private var code: String
    @Binding private var showingCopied: Bool
    
    init(oneTimePassword: OneTimePassword, showingCopied: Binding<Bool>) {
        self.oneTimePassword = oneTimePassword
        self._showingCopied = showingCopied
        self.code = oneTimePassword.generateTotp()
    }
    
    var body: some View {
        TimelineView(OneTimePasswordSchedule(period: oneTimePassword.period)) { context in
            ZStack {
                Text("COPIED")
                    .font(CodeView.codeFont)
                    .foregroundStyle(.green)
                    .opacity(showingCopied ? 1 : 0)
                    .offset(y: showingCopied ? 0 : 45)
                    .scaleEffect(showingCopied ? 1 : 0, anchor: .bottom)
                    .id("copied")
                Text(code)
                    .font(CodeView.codeFont)
                    .foregroundStyle(.blue)
                    .id(code)
                    .opacity(showingCopied ? 0 : 1)
                    .offset(y: showingCopied ? -45 : 0)
                    .scaleEffect(showingCopied ? 0 : 1, anchor: .top)
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .scale(scale: 0, anchor: .bottom)),
                            removal: .move(edge: .top).combined(with: .scale(scale: 0, anchor: .top))
                        )
                    )
            }
            .onChange(of: showingCopied) { _, new in
                if new {
                    DispatchQueue.main.asyncAfter(deadline: .now() + CodeView.resetCopyDelay, execute: toggleShowingCopied)
                }
            }
            .onChange(of: context.date) { _, _ in
                withAnimation {
                    code = oneTimePassword.generateTotp()
                }
            }
        }
    }
    
    private func toggleShowingCopied() {
        withAnimation {
            showingCopied = false
        }
    }
}

#Preview {
    CodeView(oneTimePassword: .init(label: "Test", issuer: "Test", account: "Test", secret: "Hello World".data(using: .utf8)!, period: 10, digits: 6, algorithm: .sha1), showingCopied: .constant(false))
}
