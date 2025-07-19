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
    @EnvironmentObject var oneTimePasswordService: OneTimePasswordService
    
    @State var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            StartScreen()
                .onAppear {
                    Task {
                        do {
                            try oneTimePasswordService.loadOneTimePasswords()
                        } catch {
                            print(error)
                        }
                    }
                }
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .scan:
                        ScannerView(scannedOneTimePassword: { otp in
                            do {
                                try self.oneTimePasswordService.addOneTimePassword(otp)
                            } catch {
                                print(error)
                            }
                        })
                    case .createManual:
                        CreateOneTimePasswordView(createdOtp: { otp in
                            do {
                                try self.oneTimePasswordService.addOneTimePassword(otp)
                                path.removeLast()
                            } catch {
                                print(error)
                            }
                        })
                    case .oneTimePasswordDetails(let item):
                        DetailsView(oneTimePassword: item, deleteOtp: { oneTimePasswordService.markForDeletion(item) })
                    }
                }
                .alert(
                    "Delete One Time Password",
                    isPresented: $oneTimePasswordService.showDeletionConfirmation,
                    presenting: oneTimePasswordService.deletionMarkedOTP,
                    actions: { item in
                        Button(role: .destructive, action: deleteMarkedOTP) {
                            Text("Delete")
                        }
                    },
                    message: { item in
                        Text("Are you sure you want to delete \(item.label)? You may loose access to your account, if you did not remove the multi-factor authentication requirement from your account settings, or back this OTP up somewhere else.")
                    }
                )
        }
    }
    
    func deleteMarkedOTP() {
        do {
            try oneTimePasswordService.deleteMarkedOneTimePassword()
        } catch {
            print(error)
        }
    }
}
