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
    @State var oneTimePasswordService: OneTimePasswordService
    @State var modelContainer: ModelContainer
    
    init() {
        let modelContainer = try! ModelContainer(for: OneTimePasswordEntity.self, configurations: .init())
        let authenticator = Authenticator()
        let store = SecretStore(context: authenticator.context)
        
        self.authenticator = authenticator
        self.store = store
        self.oneTimePasswordService = .init(modelContext: ModelContext(modelContainer), secretStore: store)
        self.modelContainer = modelContainer
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(modelContainer)
        .environmentObject(authenticator)
        .environmentObject(oneTimePasswordService)
    }
}
