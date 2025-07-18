//
//  OneTimePasswordService.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 17.07.25.
//

import Foundation
import SwiftData

class OneTimePasswordService: ObservableObject {
    private let modelContext: ModelContext
    private let store: SecretStore
    
    @Published var oneTimePasswords: [OneTimePassword] = []
    
    init(modelContext: ModelContext, secretStore: SecretStore) {
        self.modelContext = modelContext
        self.store = secretStore
    }
    
    func loadOneTimePasswords() throws {
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
    }
    
    func addOneTimePassword(_ oneTimePassword: OneTimePassword) throws {
        modelContext.insert(OneTimePasswordEntity(from: oneTimePassword))
        do {
            try self.store.save(forIdentifier: oneTimePassword.id.uuidString, oneTimePassword.secret)
            try modelContext.save()
        } catch {
            modelContext.rollback()
            throw error
        }
    }
    
    func removeOneTimePassword(byId id: UUID) throws {
        try modelContext.delete(model: OneTimePasswordEntity.self, where: #Predicate { $0.id == id })
        do {
            try store.delete(forIdentifier: id.uuidString)
            try modelContext.save()
        } catch {
            modelContext.rollback()
            throw error
        }
    }
}
