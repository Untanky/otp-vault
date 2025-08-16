//
//  CoreView.swift
//  iOS
//
//  Created by Lukas Grimm on 16.08.25.
//

import SwiftData
import SwiftUI

struct CoreView<Content: View>: View {
    @State private var path = NavigationPath()
    
    @StateObject private var oneTimePasswordService: OneTimePasswordService
    private let content: () -> Content
    
    init(modelContext: ModelContext, authenticationContext: AuthenticationContext, @ViewBuilder content: @escaping () -> Content) {
        let secretStore = SecretStore(context: authenticationContext.localAuthenticationContext)
        self._oneTimePasswordService = StateObject(wrappedValue: OneTimePasswordService(modelContext: modelContext, secretStore: secretStore))
        self.content = content
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            content()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .scan:
                        ScannerView(scannedOneTimePassword: addOTP)
                    case .createManual:
                        CreateOneTimePasswordView(createdOtp: addOTP)
                    case .oneTimePasswordDetails(let item):
                        DetailsView(oneTimePassword: item, updateOtp: updateOTP, deleteOtp: { oneTimePasswordService.markForDeletion(item) })
                    }
                }
        }
        .onAppear {
            do {
                try oneTimePasswordService.loadOneTimePasswords()
            } catch {
                print(error)
            }
        }
        .environmentObject(oneTimePasswordService)
    }
    
    private func addOTP(_ otp: OneTimePassword) {
        do {
            try oneTimePasswordService.addOneTimePassword(otp)
        } catch {
            print(error)
        }
    }
    
    private func updateOTP(_ otp: OneTimePassword) {
        do {
            try oneTimePasswordService.updateOneTimePassword(otp)
        } catch {
            print(error)
        }
    }
    
    private func deleteOTP() {
        do {
            try oneTimePasswordService.deleteMarkedOneTimePassword()
        } catch {
            print(error)
        }
    }
}
