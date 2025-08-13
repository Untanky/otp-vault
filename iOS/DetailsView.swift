//
//  DetailsView.swift
//  OTPVault
//
//  Created by Lukas Grimm on 11.07.25.
//

import SwiftUI

struct DetailsView: View {
    let oneTimePassword: OneTimePassword
    let copyCode: (String) -> Void
    let deleteOtp: () -> Void
    
    @State private var showingCopied = false

    var body: some View {
        List {
            Section("Settings") {
                LabeledContent("Label", value: oneTimePassword.label)
                LabeledContent("Issuer", value: oneTimePassword.issuer)
                LabeledContent("Account", value: oneTimePassword.account)
                LabeledContent("Code") {
                    Button(action: {
                        withAnimation() {
                            showingCopied  = true
                        }
                        copyCode(oneTimePassword.generateTotp())
                    }) {
                        HStack {
                            CircularTimerView()
                            CodeView(oneTimePassword: oneTimePassword, showingCopied: $showingCopied)
                        }
                    }
                }
            }
            
            Section {
                DisclosureGroup("Technical Details") {
                    LabeledContent("Period", value: "\(Int(oneTimePassword.period)) s")
                    LabeledContent("Algorithm", value: oneTimePassword.algorithm.rawValue)
                    LabeledContent("Digits", value: String(oneTimePassword.digits))
                }
                
                Button(action: copyUrl) {
                    Label("Copy Setup URL", systemImage: "document.on.document")
                }
            }
            
            Section {
                Button(action: deleteOtp) {
                    Label("Delete", systemImage: "trash")
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("Details")
    }
    
    private func copyUrl() {
        
    }
}

#Preview {
    DetailsView(oneTimePassword: OneTimePassword(
        label: "Test",
        issuer: "ACME Inc.",
        account: "Account",
        secret: "Secret".data(using: .utf8)!,
        period: TimeInterval(30),
        digits: 6,
        algorithm: .sha1
    ), copyCode: { text in }, deleteOtp: { })
}
