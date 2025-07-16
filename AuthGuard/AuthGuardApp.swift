//
//  AuthGuardApp.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 10.07.25.
//

import CodeScanner
import SwiftUI
import SwiftData

@main
struct AuthGuardApp: App {
    @State var authenticator: Authenticator
    @State var store: SecretStore
    
    init() {
        let authenticator = Authenticator()
        self.authenticator = authenticator
        self.store = .init(context: authenticator.context)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(store: SecretStore(context: authenticator.context))
        }
        .modelContainer(for: [OneTimePasswordEntity.self])
        .environmentObject(authenticator)
    }
}
