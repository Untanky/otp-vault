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
    @EnvironmentObject var authenticator: Authenticator
    @EnvironmentObject var oneTimePasswordService: OneTimePasswordService
    
    var body: some View {
        if !authenticator.authenticated {
            return AnyView(AuthenticationView {
                Task {
                    await authenticator.authenticate()
                }
            })
        } else {
            return AnyView(ListView(oneTimePasswords: oneTimePasswordService.oneTimePasswords, deleteOtp: { id in
                Task {
                    do {
                        try oneTimePasswordService.removeOneTimePassword(byId: id)
                    } catch {
                        print(error)
                    }
                }
            })
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
            )
        }
    }
}
