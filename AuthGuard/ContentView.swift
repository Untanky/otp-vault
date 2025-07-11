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
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Authenticator())
}
