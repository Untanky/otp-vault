//
//  ContentView.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 15.07.25.
//

import SwiftData
import SwiftUI

enum Route: Hashable {
    case scan
    case createManual
    case oneTimePasswordDetails(item: OneTimePassword)
}

struct ContentView: View {
    @EnvironmentObject var authenticator: Authenticator
    @Environment(\.modelContext) private var modelContext
    
    @State var path = NavigationPath()
    
    var store: SecretStore
    
    var body: some View {
        NavigationStack(path: $path) {
            StartScreen(store: store)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .scan:
                        ScannerView(scannedOneTimePassword: addOneTimePassword)
                    case .createManual:
                        CreateOneTimePasswordView(createdOtp: addOneTimePassword)
                    case .oneTimePasswordDetails(let item):
                        OneTimePasswordDetailsView(oneTimePassword: item)
                    }
                }
        }
    }
    
    private func addOneTimePassword(_ oneTimePassword: OneTimePassword) {
        modelContext.insert(OneTimePasswordEntity(from: oneTimePassword))
        do {
            try self.store.save(forIdentifier: oneTimePassword.id.uuidString, oneTimePassword.secret)
            try modelContext.save()
            path.removeLast()
        } catch {
            print(error)
        }
    }
}
