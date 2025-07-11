//
//  ContentView.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 10.07.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    let items: [OneTimePasswordItem] = [
        OneTimePasswordItem(title: "Platform 1", account: "Account 1", secret: "abc".data(using: .utf8)!, interval: TimeInterval(30)),
        OneTimePasswordItem(title: "Platform 2", account: "Account 2", secret: "def".data(using: .utf8)!, interval: TimeInterval(30)),
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
    ContentView()
}
