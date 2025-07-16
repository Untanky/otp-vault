//
//  StartScreen.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 11.07.25.
//

import LocalAuthentication
import SwiftData
import SwiftUI

struct StartScreen: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var authenticator: Authenticator
    var store: SecretStore
    
    @State var oneTimePasswords: [OneTimePassword] = []
    
    var body: some View {
        if !authenticator.authenticated {
            AuthenticationView {
                Task {
                    await authenticator.authenticate()
                }
            }
        } else {
            OneTimePasswordListView(oneTimePasswords: oneTimePasswords)
                .navigationTitle("One-Time Passwords")
                .toolbarBackground(Color.accentColor, for: .bottomBar)
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        NavigationLink(value: "manuallyAdd") {
                            Image(systemName: "plus")
                        }
                    }
                    ToolbarItem(placement: .bottomBar) {
                        NavigationLink(value: Route.scan) {
                            Image(systemName: "qrcode.viewfinder")
                        }
                    }
                }
                .searchable(text: .constant(""), prompt: "Search")
                .onAppear {
                    do {
                        let entities = try modelContext.fetch(FetchDescriptor<OneTimePasswordEntity>())
                        
                        oneTimePasswords = try entities.map { entity in
                            let secret = try self.store.retrieve(forIdentifier: entity.id.uuidString)
                            return OneTimePassword(id: entity.id, label: entity.label, issuer: entity.issuer, account: entity.account, secret: secret, period: TimeInterval(entity.period), digits: entity.digits, algorithm: entity.algorithm)
                        }
                    } catch {
                        print(error)
                    }
                }
        }
    }
}
