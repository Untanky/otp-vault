//
//  AuthGuardApp.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 10.07.25.
//

import CodeScanner
import SwiftUI
import SwiftData

enum Route {
    case scan
}

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
            NavigationStack {
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
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .scan:
                            ScannerView()
                        }
                    }
            }
        }
    }
    
    private func handleScan(result: Result<ScanResult, ScanError>) {
        // TODO: add qr-code handling
    }
}
