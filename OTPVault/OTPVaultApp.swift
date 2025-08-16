//
//  OTPVaultApp.swift
//  OTPVault
//
//  Created by Lukas Grimm on 10.07.25.
//

import CodeScanner
import SwiftUI
import SwiftData

@main
struct OTPVaultApp: App {
    @State var modelContainer: ModelContainer
    
    init() {
        let modelContainer = try! ModelContainer(for: OneTimePasswordEntity.self, configurations: .init())
        self.modelContainer = modelContainer
    }
    
    var body: some Scene {
        WindowGroup {
            AuthenticationView {
                Text("Hello World!")
            }
        }
        .modelContainer(modelContainer)
    }
}
