//
//  Authenticator.swift
//  OTPVault
//
//  Created by Lukas Grimm on 11.07.25.
//

import LocalAuthentication
import SwiftUI

@MainActor
class Authenticator: ObservableObject {
    enum State {
        case unknown
        case unauthenticated
        case authenticating
        case authenticated
    }
    
    let context: LAContext
    @Published var state: State = .unauthenticated
    
    init() {
        self.context = .init()
    }
    
    func authenticate() async {
        self.state = .authenticating
        do {
            var error: NSError?
            context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
            if error != nil {
                self.state = .unauthenticated
                return
            }
            
            try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Authenticate")
            self.state = .authenticated
        } catch {
            self.state = .unauthenticated
        }
    }
    
    func invalidate() {
        self.state = .unauthenticated
    }
}
