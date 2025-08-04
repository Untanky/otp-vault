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
            Image("Logo")
                .resizable()
                .frame(width: 196, height: 196)
            Text("AuthGuard is locked!")
                .font(.title)
                .fontWeight(.bold)
            Button(action: onAuthenticateTap) {
                Label("Unlock", systemImage: "lock.open")
            }
            .buttonStyle(.borderedProminent)
            Text("Please unlock to use")
                .font(.callout)
                .foregroundStyle(.secondary)
                .padding(.top, 4)
        }
    }
}

#Preview {
    AuthenticationView(onAuthenticateTap: { })
}
