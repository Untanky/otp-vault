//
//  AuthGuardApp.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 10.07.25.
//

import CodeScanner
import SwiftUI
import SwiftData

enum Route: Hashable {
    case scan
    case oneTimePasswordDetails(item: OneTimePassword)
}

@main
struct AuthGuardApp: App {
    @State var path = NavigationPath()
    @State var authenticator: Authenticator
    let store: SecretStore
    
    init() {
        let authenticator = Authenticator()
        self.authenticator = authenticator
        self.store = .init(context: authenticator.context)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                ContentView()
                    .environmentObject(authenticator)
                    .onAppear {
                        do {
                            try self.store.save(forIdentifier: "test", "foo".data(using: .utf8)!)
                            let data = try self.store.retrieve(forIdentifier: "test")
                        } catch {
                            print(error)
                        }
                    }
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .scan:
                            ScannerView(path: $path)
                        case .oneTimePasswordDetails(let item):
                            OneTimePasswordDetails(oneTimePassword: item)
                        }
                    }
            }
        }
    }
    
    private func handleScan(result: Result<ScanResult, ScanError>) {
        // TODO: add qr-code handling
    }
}
