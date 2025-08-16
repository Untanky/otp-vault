//
//  DetailsEditView.swift
//  iOS
//
//  Created by Lukas Grimm on 13.08.25.
//

import SwiftUI

struct DetailsEditValues {
    let label: String
    let account: String
    let issuer: String
}

struct DetailsEditView: View {
    @State private var label: String = ""
    @State private var account: String = ""
    @State private var issuer: String = ""
    
    let onSubmit: (DetailsEditValues) -> Void
    let onCancel: () -> Void
    
    init(label: String, account: String, issuer: String, onCancel: @escaping () -> Void, onSubmit: @escaping (DetailsEditValues) -> Void) {
        self.label = label
        self.account = account
        self.issuer = issuer
        self.onCancel = onCancel
        self.onSubmit = onSubmit
    }
    
    var body: some View {
        Form {
            LabeledContent {
                TextField(text: $label, label: { Text("Label") })
                    .multilineTextAlignment(.trailing)
            } label:  {
                Text("Label")
                    .foregroundStyle(.secondary)
            }
            LabeledContent {
                TextField(text: $account, label: { Text("Account") })
                    .multilineTextAlignment(.trailing)
            } label:  {
                Text("Account")
                    .foregroundStyle(.secondary)
            }
            LabeledContent {
                TextField(text: $issuer, label: { Text("Issuer") })
                    .multilineTextAlignment(.trailing)
            } label:  {
                Text("Issuer")
                    .foregroundStyle(.secondary)
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: { onCancel() }) {
                    Label("Cancel", systemImage: "xmark")
                }
            }
            ToolbarItem(placement: .primaryAction) {
                Button(action: { onSubmit(.init(label: label, account: account, issuer: issuer)) }) {
                    Label("Save", systemImage: "checkmark")
                }
                .tint(.accentColor)
            }
        }
    }
}

#Preview {
    NavigationView {
        DetailsEditView(label: "", account: "", issuer: "", onCancel: { print("cancel") }, onSubmit: { values in print(values) })
    }
}
