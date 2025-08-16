//
//  HomeScreen.swift
//  OTPVault
//
//  Created by Lukas Grimm on 11.07.25.
//

import LocalAuthentication
import SafariServices
import SwiftData
import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject private var oneTimePasswordService: OneTimePasswordService
    
    var body: some View {
        Group {
            if oneTimePasswordService.oneTimePasswords.isEmpty {
                ContentUnavailableView {
                    Label("No One-Time Passwords", systemImage: "ellipsis.rectangle")
                } description: {
                    Text("You have not created any One-Time Passwords yet.")
                } actions: {
                    NavigationLink(value: Route.scan) {
                        Label("Scan QR Code", systemImage: "qrcode.viewfinder")
                    }
                    .buttonStyle(.borderedProminent)
                    NavigationLink(value: Route.createManual) {
                        Label("Manually add", systemImage: "plus.circle")
                    }
                    .buttonStyle(.bordered)
                }
            } else {
                ListView(oneTimePasswords: oneTimePasswordService.oneTimePasswords, deleteOtp: oneTimePasswordService.markForDeletion)
            }
        }
            .navigationTitle("One-Time Passwords")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    NavigationLink(destination: AboutScreen(), label: {
                        Image(systemName: "ellipsis.circle")
                    })
                }
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
    }
}
