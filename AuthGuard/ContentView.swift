//
//  ContentView.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 11.07.25.
//

import LocalAuthentication
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authenticator: Authenticator
    
    var body: some View {
        if !authenticator.authenticated {
            AuthenticationView {
                Task {
                    await authenticator.authenticate()
                }
            }
        } else {
            OneTimePasswordListView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Authenticator())
}
