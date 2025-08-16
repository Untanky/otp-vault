//
//  DetailsView.swift
//  OTPVault
//
//  Created by Lukas Grimm on 11.07.25.
//

import SwiftUI

struct DetailsView: View {
    let oneTimePassword: OneTimePassword
    let updateOtp: (OneTimePassword) -> Void
    let deleteOtp: () -> Void
    
    @State private var isEditing = false
    
    var body: some View {
        List {
            Section("Settings") {
                LabeledContent("Label", value: oneTimePassword.label)
                LabeledContent("Issuer", value: oneTimePassword.issuer)
                LabeledContent("Account", value: oneTimePassword.account)
                LabeledContent("Code") {
                    CodeWithTimer(oneTimePassword: oneTimePassword)
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
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { isEditing = true }) {
                    Label("Edit", systemImage: "pencil")
                }
            }
        }
        .inspector(isPresented: $isEditing) {
            NavigationView {
                DetailsEditView(label: oneTimePassword.label, account: oneTimePassword.account, issuer: oneTimePassword.issuer, onCancel: { isEditing = false }, onSubmit: updateOneTimePassword)
                    .navigationTitle("Update OTP")
            }
                .presentationDetents([.large])
                .presentationDragIndicator(.hidden)
        }
    }
    
    private func updateOneTimePassword(_ otp: DetailsEditValues) {
        updateOtp(.init(id: oneTimePassword.id, label: otp.label, issuer: otp.issuer, account: otp.account, secret: oneTimePassword.secret, period: oneTimePassword.period, digits: oneTimePassword.digits, algorithm: oneTimePassword.algorithm))
        isEditing = false
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
    ), updateOtp: { otp in }, deleteOtp: { })
}
