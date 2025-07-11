//
//  Authenticator.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 11.07.25.
//

import LocalAuthentication

@MainActor
class Authenticator: ObservableObject {
    enum State {
        case unknown
        case unauthenticated
        case authenticating
        case authenticated
    }
    
    let context: LAContext
    @Published private(set) var state: State = .unauthenticated {
        didSet {
            authenticated = state == .authenticated
        }
    }
    @Published private(set) var authenticated: Bool = false
    
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
            print(error)
            self.state = .unauthenticated
        }
    }
    
    func invalidate() {
        self.state = .unauthenticated
    }
}
