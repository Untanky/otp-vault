//
//  AuthenticationView.swift
//  OTPVault
//
//  Created by Lukas Grimm on 16.08.25.
//

import LocalAuthentication
import SwiftUI

enum AuthenticationError: Error {
    case biometryNotAvailable
    case authenticationFailed(_ reason: Error)
    
    var localizedDescription: String {
        switch self {
        case .biometryNotAvailable:
            return "FaceID not available"
        case .authenticationFailed(let reason):
            return "Authentication failed: \(reason)"
        }
    }
}

class AuthenticationContext: ObservableObject {
    let localAuthenticationContext: LAContext
    
    init() {
        localAuthenticationContext = LAContext()
    }
    
    func authenticate() async throws {
        var error: NSError?
        localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
        if error != nil {
            throw AuthenticationError.biometryNotAvailable
        }
        
        do {
            try await localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Authenticate")
        } catch {
            throw AuthenticationError.authenticationFailed(error)
        }
    }
}

struct AuthenticationView<Content: View>: View {
    @State private var isAuthenticated: Bool = false
    @State private var error: Error? = nil
    @State private var context = AuthenticationContext()
    
    private let content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        ZStack {
            if isAuthenticated {
                content()
            }
            
            FullScreenCoverView(isPresented: !isAuthenticated) {
                ZStack {
                    VStack {
                        Image("Logo")
                            .resizable()
                            .frame(width: 196, height: 196)
                        Text("OTP Vault")
                            .font(.system(size: 32, weight: .bold, design: .default))
                        Button(action: authenticate) {
                            biometryLabel
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    if error != nil {
                        VStack {
                            Spacer()
                            HStack(alignment: .top) {
                                Image(systemName: "exclamationmark.triangle")
                                Text("Something went wrong") // TODO: handle errors correctly
                            }
                            .foregroundStyle(.red)
                            .padding(8)
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Material.thin)
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 32)
                        }
                    }
                }
            }
        }
        .onAppear {
            authenticate()
        }
        .environmentObject(context)
    }
    
    private var biometryLabel: some View {
        switch context.localAuthenticationContext.biometryType {
        case .faceID:
            Label("Unlock with FaceID", systemImage: "faceid")
        case .opticID:
            Label("Unlock with OpticID", systemImage: "opticid")
        case .touchID:
            Label("Unlock with TouchID", systemImage: "touchid")
        default:
            Label("Unlock", systemImage: "lock")
        }
    }
    
    private func authenticate() {
        Task {
            do {
                try await context.authenticate()
                self.isAuthenticated = true
            } catch {
                self.error = error
            }
        }
    }
}
