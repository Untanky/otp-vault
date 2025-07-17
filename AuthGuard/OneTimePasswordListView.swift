//
//  ContentView.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 10.07.25.
//

import SwiftUI
import SwiftData

struct OneTimePasswordListView: View {
    let oneTimePasswords: [OneTimePassword]
    let deleteOtp: (UUID) -> Void
    
    var body: some View {
        if oneTimePasswords.isEmpty {
            Text("No One-Time Passwords found.")
        } else {
            List(oneTimePasswords) { otp in
                OneTimePasswordItemView(item: otp, onClickCode: { copyToClipboard($0) })
                    .contextMenu {
                        NavigationLink(value: Route.oneTimePasswordDetails(item: otp)) {
                            Label("Show Details", systemImage: "info.circle")
                        }
                        Button(action: { copyToClipboard(otp.generateTotp()) }) {
                            Label("Copy Code", systemImage: "document.on.clipboard")
                        }
                        Button(role: .destructive, action: {
                            deleteOtp(otp.id)
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
                        Button(action: { deleteOtp(otp.id) }) {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                    }
            }
            .listStyle(.insetGrouped)
        }
    }
    
    private func copyToClipboard(_ text: String) {
        UIPasteboard.general.string = text
    }
}

#Preview {
    OneTimePasswordListView(oneTimePasswords: [
        OneTimePassword(label: "Code 1", issuer: "ACME Inc.", account: "john.doe@example.com", secret: "abc".data(using: .utf8)!, period: TimeInterval(30), digits: 6, algorithm: .sha1),
        OneTimePassword(label: "Code 2", issuer: "ACME Inc.", account: "john.doe@example.com", secret: "def".data(using: .utf8)!, period: TimeInterval(30), digits: 6, algorithm: .sha1),
        OneTimePassword(label: "Code 3", issuer: "ACME Inc.", account: "john.doe@example.com", secret: "ghi".data(using: .utf8)!, period: TimeInterval(30), digits: 6, algorithm: .sha1),
    ], deleteOtp: { _ in })
}

#Preview("Empty OneTimePasswordListView") {
    OneTimePasswordListView(oneTimePasswords: [], deleteOtp: { _ in })
}
