//
//  RootView.swift
//  OTPVault
//
//  Created by Lukas Grimm on 15.07.25.
//

import SwiftUI

enum Route: Hashable {
    case scan
    case createManual
    case oneTimePasswordDetails(item: OneTimePassword)
}

struct RootView: View {
    @EnvironmentObject private var authenticator: Authenticator
    @EnvironmentObject private var oneTimePasswordService: OneTimePasswordService
    
    @State private var path = NavigationPath()
    
    @State private var authenticated = false
    
    var body: some View {
        ZStack {
            NavigationStack(path: $path) {
                HomeScreen()
                    .onAppear {
                        Task {
                            loadOTPs();
                        }
                    }
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
                    .confirmationDialog(
                        "Delete One Time Password",
                        isPresented: $oneTimePasswordService.showDeletionConfirmation,
                        titleVisibility: .visible,
                        presenting: oneTimePasswordService.deletionMarkedOTP,
                        actions: { _ in
                            Button(role: .destructive, action: deleteMarkedOTP) {
                                Text("Delete")
                            }
                        },
                        message: { item in
                            Text("Are you sure you want to delete \(item.label)? You may loose access to your account, if you did not remove the multi-factor authentication requirement from your account settings, or back this OTP up somewhere else.")
                        }
                    )
            }

            FullScreenCoverView(isPresented: !authenticated) {
                AuthenticationView(onAuthenticateTap: {
                    Task {
                        await authenticator.authenticate()
                    }
                })
            }
        }
        .onChange(of: authenticator.state) { oldValue, newValue in
            authenticated = newValue == .authenticated
        }
    }
    
    private func loadOTPs() {
        do {
            try oneTimePasswordService.loadOneTimePasswords()
        } catch {
            print(error)
        }
    }
    
    private func addOTP(_ otp: OneTimePassword) {
        do {
            try self.oneTimePasswordService.addOneTimePassword(otp)
            path.removeLast()
        } catch {
            print(error)
        }
    }
    
    private func updateOTP(_ otp: OneTimePassword) {
        do {
            try self.oneTimePasswordService.updateOneTimePassword(otp)
        } catch {
            print(error)
        }
    }
    
    private func deleteMarkedOTP() {
        withAnimation {
            do {
                try oneTimePasswordService.deleteMarkedOneTimePassword()
            } catch {
                print(error)
            }
        }
    }
}
