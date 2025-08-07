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
    @EnvironmentObject private var authenticator: Authenticator
    
    @State private var searchText: String = ""
    
    private var filteredOneTimePasswords: [OneTimePassword] {
        if searchText.isEmpty {
            return oneTimePasswordService.oneTimePasswords
        }
        
        return oneTimePasswordService.oneTimePasswords.filter { otp in
            return otp.account.localizedCaseInsensitiveContains(searchText) ||
            otp.label.localizedCaseInsensitiveContains(searchText) ||
            otp.issuer.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        ListView(oneTimePasswords: filteredOneTimePasswords, isFiltered: !searchText.isEmpty, deleteOtp: oneTimePasswordService.markForDeletion)
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
        .onAppear {
            Task {
                await authenticator.authenticate()
            }
        }
        .searchable(text: $searchText, prompt: "Search")
    }
}
