//
//  ListView.swift
//  OTPVault
//
//  Created by Lukas Grimm on 10.07.25.
//

import SwiftUI
import SwiftData

struct ListView: View {
    let oneTimePasswords: [OneTimePassword]
    let deleteOtp: (OneTimePassword) -> Void
    
    @State private var searchText: String = ""
    
    private var filteredOneTimePasswords: [OneTimePassword] {
        if searchText.isEmpty {
            return oneTimePasswords
        }
        
        return oneTimePasswords.filter { otp in
            return otp.account.localizedCaseInsensitiveContains(searchText) ||
            otp.label.localizedCaseInsensitiveContains(searchText) ||
            otp.issuer.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        Group {
            if filteredOneTimePasswords.isEmpty {
                ContentUnavailableView {
                    Label("No One-Time Passwords found", systemImage: "ellipsis.rectangle")
                } description: {
                    Text("Try another search query.")
                }
            } else {
                List(filteredOneTimePasswords) { otp in
                    ListItemView(item: otp)
                        .contextMenu {
                            NavigationLink(value: Route.oneTimePasswordDetails(item: otp)) {
                                Label("Show Details", systemImage: "info.circle")
                            }
                            Button(action: { copyToClipboard(otp.generateTotp()) }) {
                                Label("Copy Code", systemImage: "document.on.clipboard")
                            }
                            Button(role: .destructive, action: {
                                deleteOtp(otp)
                            }) {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button(action: { copyToClipboard(otp.generateTotp()) }) {
                                Label("Copy Code", systemImage: "document.on.clipboard")
                            }
                            .tint(.green)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(action: { deleteOtp(otp) }) {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                        .transition(
                            .asymmetric(
                                insertion: .identity,
                                removal: .scale
                            )
                        )
                }
                .animation(.easeInOut(duration: 0.3), value: oneTimePasswords)
                .listStyle(.inset)
            }
        }
            .searchable(text: $searchText, prompt: "Search codes")
    }
    
    private func copyToClipboard(_ text: String) {
        UIPasteboard.general.string = text
    }
}

#Preview {
    ListView(oneTimePasswords: [
        OneTimePassword(label: "Code 1", issuer: "ACME Inc.", account: "john.doe@example.com", secret: "abc".data(using: .utf8)!, period: TimeInterval(30), digits: 6, algorithm: .sha1),
        OneTimePassword(label: "Code 2", issuer: "ACME Inc.", account: "john.doe@example.com", secret: "def".data(using: .utf8)!, period: TimeInterval(30), digits: 6, algorithm: .sha1),
        OneTimePassword(label: "Code 3", issuer: "ACME Inc.", account: "john.doe@example.com", secret: "ghi".data(using: .utf8)!, period: TimeInterval(30), digits: 6, algorithm: .sha1),
        OneTimePassword(label: "Veryyyy loooooooooooooong label", issuer: "ACME Inc.", account: "looooooooooong.email@example.com", secret: "ghi".data(using: .utf8)!, period: TimeInterval(30), digits: 6, algorithm: .sha1),
    ], deleteOtp: { _ in })
}

#Preview("Empty OneTimePasswordListView") {
    ListView(oneTimePasswords: [], deleteOtp: { _ in })
}
