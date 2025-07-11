//
//  AuthenticationView.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 11.07.25.
//

import LocalAuthentication
import SwiftUI

struct AuthenticationView: View {
    let onAuthenticateTap: () -> Void
    
    var body: some View {
        VStack {
            Text("Please Authenticate")
            Button(action: onAuthenticateTap) {
                Text("Login")
            }
            .buttonStyle(.borderedProminent)
        }
        .onAppear {
            onAuthenticateTap()
        }
    }
}

#Preview {
    AuthenticationView(onAuthenticateTap: { })
}
