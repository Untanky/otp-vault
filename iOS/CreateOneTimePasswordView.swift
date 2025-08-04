//
//  CreateOneTimePasswordView.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 16.07.25.
//

import SwiftUI

struct CreateOneTimePasswordView: View {
    private struct CreateOneTimePassword {
        var label: String
        var issuer: String
        var account: String
        var secret: String
        var period: Int
        var digits: Int
        var algorithm: Algorithm
    }
    
    @State private var oneTimePassword: CreateOneTimePassword = .init(label: "", issuer: "", account: "", secret: "", period: 30, digits: 6, algorithm: .sha1)
    
    @State private var showSecretError = false
    
    let createdOtp: (OneTimePassword) -> Void
    
    init(createdOtp: @escaping (OneTimePassword) -> Void) {
        self.createdOtp = createdOtp
    }
    
    var body: some View {
        Form {
            Section("Settings") {
                TextField("Label", text: $oneTimePassword.label)
            
                TextField("Account", text: $oneTimePassword.account)
                
                TextField("Secret", text: $oneTimePassword.secret)
                    .alert("Invalid secret", isPresented: $showSecretError, actions: {
                        Button(action: {
                            showSecretError = false
                        }) {
                            Text("Close")
                        }
                    }, message: {
                        Text("Secret must be a valid base32 encoded string")
                    })
                
                TextField("Issuer", text: $oneTimePassword.issuer)
            }
            
            Section {
                DisclosureGroup("Technical Details") {
                    Picker("Period", selection: $oneTimePassword.period) {
                        ForEach([15, 30, 60], id: \.self) {
                            Text("\($0) s")
                                .tag($0)
                        }
                    }
                    Picker("Digits", selection: $oneTimePassword.digits) {
                        ForEach([6, 7, 8], id: \.self) {
                            Text("\($0)")
                                .tag($0)
                        }
                    }
                    Picker("Algorithm", selection: $oneTimePassword.algorithm) {
                        ForEach(Algorithm.allCases) {
                            Text($0.rawValue)
                                .tag($0)
                        }
                    }
                }
            } header: {
                Text("Advanced Settings")
            } footer: {
                Text("Only adjust these settings, if you know what you are doing.")
            }
        }
        .navigationTitle("Add Code")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: save) {
                    Text("Save")
                }
                .disabled(oneTimePassword.account.isEmpty || oneTimePassword.label.isEmpty || oneTimePassword.secret.isEmpty || oneTimePassword.issuer.isEmpty)
            }
        }
    }
    
    func save() {
        guard let secret = oneTimePassword.secret.base32DecodedData() else {
            showSecretError = true
            return;
        }
        
        createdOtp(.init(label: oneTimePassword.label, issuer: oneTimePassword.issuer, account: oneTimePassword.account, secret: secret, period: TimeInterval(oneTimePassword.period), digits: oneTimePassword.digits, algorithm: oneTimePassword.algorithm))
    }
}

#Preview {
    NavigationView {
        CreateOneTimePasswordView(createdOtp: { _ in })
    }
}
