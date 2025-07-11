//
//  AuthGuardApp.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 10.07.25.
//

import SwiftUI
import SwiftData

@main
struct AuthGuardApp: App {
    @State var authenticator: Authenticator
    let store: SecretStore
    
    init() {
        let authenticator = Authenticator()
        self.authenticator = authenticator
        self.store = .init(context: authenticator.context)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authenticator)
                .onAppear {
                    do {
                        try self.store.save(forIdentifier: "test", "foo".data(using: .utf8)!)
                        let data = try self.store.retrieve(forIdentifier: "test")
                        print(String(data: data, encoding: .utf8)!)
                    } catch {
                        print(error)
                    }
                }
        }
    }
}
