//
//  DetailsView.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 11.07.25.
//

import SwiftUI

struct DetailsView: View {
    let oneTimePassword: OneTimePassword
    let deleteOtp: (UUID) -> Void

    var body: some View {
        Form {
            Section("Settings") {
                TextField("Label", text: .constant(oneTimePassword.label))
                TextField("Account", text: .constant(oneTimePassword.account))
                Text("(Secret is not shown)")
                    .foregroundStyle(.secondary)
                TextField("Issuer", text: .constant(oneTimePassword.issuer))
            }
            
            Section {
                DisclosureGroup("Technical Details") {
                    LabeledContent("Period", value: String(format: "%i s", oneTimePassword.period))
                    LabeledContent("Algorithm", value: oneTimePassword.algorithm.rawValue)
                    LabeledContent("Digits", value: String(oneTimePassword.digits))
                }
            }
           
            Section {
                Button(action: { deleteOtp(oneTimePassword.id) }) {
                    Label("Delete", systemImage: "trash")
                        .foregroundStyle(.red)
                }
            }
        }
        .navigationTitle("Details")
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
    ), deleteOtp: { _ in })
}
