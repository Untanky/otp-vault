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
            return AnyView(AuthenticationView {
                Task {
                    await authenticator.authenticate()
                }
            })
        } else {
            return AnyView(OneTimePasswordListView(oneTimePasswords: oneTimePasswords, deleteOtp: deleteOneTimePassword)
                .navigationTitle("One-Time Passwords")
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        NavigationLink(value: Route.createManual) {
                            Image(systemName: "plus")
                        }
                    }
                    ToolbarItem(placement: .bottomBar) {
                        NavigationLink(value: Route.scan) {
                            Image(systemName: "qrcode.viewfinder")
                        }
                    }
                }
                .onAppear {
                    do {
                        let entities = try modelContext.fetch(FetchDescriptor<OneTimePasswordEntity>())
                        
                        oneTimePasswords = entities.compactMap { entity in
                            do {
                                let secret = try self.store.retrieve(forIdentifier: entity.id.uuidString)
                                return OneTimePassword(id: entity.id, label: entity.label, issuer: entity.issuer, account: entity.account, secret: secret, period: TimeInterval(entity.period), digits: entity.digits, algorithm: entity.algorithm)
                            } catch {
                                print(error)
                                return nil
                            }
                        }
                    } catch {
                        print(error)
                    }
                }
            )
        }
    }
    
    private func deleteOneTimePassword(_ id: UUID) {
        do {
            try store.delete(forIdentifier: id.uuidString)
            try modelContext.delete(model: OneTimePasswordEntity.self, where: #Predicate { $0.id == id })
            oneTimePasswords.removeAll { $0.id == id }
        } catch {
            print(error)
        }
    }
}
