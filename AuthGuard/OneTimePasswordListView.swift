//
//  ContentView.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 10.07.25.
//

import SwiftUI
import SwiftData

struct OneTimePasswordListView: View {
    
    let items: [OneTimePassword] = [
//        OneTimePassword(label: "Platform 1", issuer: "Issuer 1", account: "Account 1", secret: "abc".data(using: .utf8)!, period: TimeInterval(30), digits: 6, algorithm: .sha1),
//        OneTimePassword(label: "Platform 2", issuer: "Issuer 2", account: "Account 2", secret: "def".data(using: .utf8)!, period: TimeInterval(30), digits: 6, algorithm: .sha1),
    ]
    
    var body: some View {
        List(items) { item in
            OneTimePasswordItemView(item: item, onClickCode: { copyToClipboard($0) })
        }
        .listStyle(.insetGrouped)
    }
    
    private func copyToClipboard(_ text: String) {
        UIPasteboard.general.string = text
    }
}

#Preview {
    OneTimePasswordListView()
}
