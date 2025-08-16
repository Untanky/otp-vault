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

@MainActor
class AuthenticationContext: ObservableObject {
    @Published private(set) var localAuthenticationContext: LAContext
    
    init() {
        localAuthenticationContext = LAContext()
    }
    
    func biometricType() throws -> LABiometryType {
        try checkPolicy()
        return localAuthenticationContext.biometryType
    }
    
    func checkPolicy() throws {
        var error: NSError?
        localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
        if error != nil {
            throw AuthenticationError.biometryNotAvailable
        }
    }
    
    func authenticate() async throws {
        localAuthenticationContext = LAContext()
        do {
            try checkPolicy()
            try await localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Authenticate")
        } catch {
            throw AuthenticationError.authenticationFailed(error)
        }
    }
}

struct AuthenticationView<Content: View>: View {
    @State private var isAuthenticated: Bool = false
    @State private var error: Error? = nil
    @StateObject private var context = AuthenticationContext()
    
    private let content: (AuthenticationContext) -> Content
    
    init(@ViewBuilder content: @escaping (AuthenticationContext) -> Content) {
        self.content = content
    }
    
    var body: some View {
        ZStack {
            if isAuthenticated {
                content(context)
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
        do {
            switch try context.biometricType() {
            case .faceID:
                return Label("Unlock with FaceID", systemImage: "faceid")
            case .opticID:
                return Label("Unlock with OpticID", systemImage: "opticid")
            case .touchID:
                return Label("Unlock with TouchID", systemImage: "touchid")
            default:
                return Label("Unlock", systemImage: "lock")
            }
        } catch {
            return Label("Unlock", systemImage: "lock")
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
