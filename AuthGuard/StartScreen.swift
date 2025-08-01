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
    @EnvironmentObject private var oneTimePasswordService: OneTimePasswordService
    @EnvironmentObject private var authenticator: Authenticator
    
    var body: some View {
        ZStack {
            ListView(oneTimePasswords: oneTimePasswordService.oneTimePasswords, deleteOtp: oneTimePasswordService.markForDeletion)
                .navigationTitle("One-Time Passwords")
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        NavigationLink(value: Route.createManual) {
                            Image(systemName: "plus.circle")
                        }
                    }
                    ToolbarItem(placement: .bottomBar) {
                        NavigationLink(value: Route.scan) {
                            Image(systemName: "qrcode.viewfinder")
                        }
                    }
                }
                .onAppear {
                    Task {
                        await authenticator.authenticate()
                    }
                }
        }
        .overlay {
            Group {
                if (!authenticator.authenticated) {
                    Color.black
                        .ignoresSafeArea()
                        .overlay(
                            AuthenticationView(onAuthenticateTap: {
                                Task {
                                    await authenticator.authenticate()
                                }
                            })
                        )
                        .transition(.scale(scale: 2, anchor: .init(x: 0.5, y: 0.25)).combined(with: .opacity))
                        .animation(.default, value: authenticator.authenticated)
                }
            }
        }
    }
}
