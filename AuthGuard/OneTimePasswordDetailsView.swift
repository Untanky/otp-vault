//
//  OneTimePasswordDetailsView.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 11.07.25.
//

import SwiftUI

struct OneTimePasswordDetailsView: View {
    let oneTimePassword: OneTimePassword

    var body: some View {
        Form {
            Section {
                OneTimePasswordItemView(item: oneTimePassword, onClickCode: { _ in })
            }
            
            Section {
                LabeledContent {
                    TextField("Personal Account", text: .constant(oneTimePassword.label))
                } label: {
                    Text("Label")
                        .foregroundStyle(.secondary)
                }
                
                LabeledContent {
                    TextField("john.doe@acme.com", text: .constant(oneTimePassword.account))
                } label: {
                    Text("Account")
                        .foregroundStyle(.secondary)
                }
            }
            
            Section {
                LabeledContent {
                    Text("(Secret is not shown)")
                } label: {
                    Text("Key")
                }

                LabeledContent {
                    Text(oneTimePassword.issuer)
                } label: {
                    Text("Issuer")
                }
            }
            
            DisclosureGroup("Technical Details") {
                LabeledContent("Period", value: String(format: "%i s", oneTimePassword.period))
                LabeledContent("Algorithm", value: oneTimePassword.algorithm.rawValue)
                LabeledContent("Digits", value: String(oneTimePassword.digits))
            }
        }
    }
}

#Preview {
    OneTimePasswordDetailsView(oneTimePassword: OneTimePassword(
        label: "Test",
        issuer: "ACME Inc.",
        account: "Account",
        secret: "Secret".data(using: .utf8)!,
        period: TimeInterval(30),
        digits: 6,
        algorithm: .sha1
    ))
}
