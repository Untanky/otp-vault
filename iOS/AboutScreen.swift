//
//  AboutScreen.swift
//  iOS
//
//  Created by Lukas Grimm on 07.08.25.
//

import SafariServices
import SwiftUI

fileprivate struct SafariView: UIViewControllerRepresentable {
  let url: URL

  func makeUIViewController(context: Context) -> SFSafariViewController {
    let config = SFSafariViewController.Configuration()
    config.entersReaderIfAvailable = false
    let vc = SFSafariViewController(url: url, configuration: config)
    vc.preferredBarTintColor = .systemBackground
    vc.preferredControlTintColor = .systemBlue
    return vc
  }

  func updateUIViewController(_ uiViewController: SFSafariViewController,
                              context: Context) {
    // nothing to update
  }
}

extension URL: @retroactive Identifiable {
    public var id: String { absoluteString }
}

struct AboutScreen: View {
    private static let gitHubURL = URL(string: "https://github.com/untanky/otp-vault")!
    private static let privacyStatementURL = URL(string: "https://lukasgrimm.de/privacy-statement")!
    
    @State private var url: URL?
    
    private var version: String {
        let info    = Bundle.main.infoDictionary
        let v       = info?["CFBundleShortVersionString"] as? String ?? ""
        let build   = info?["CFBundleVersion"]        as? String ?? ""
        return "\(v) (\(build))"
    }
    
    var body: some View {
        List {
            Section {
                LabeledContent("Developer") { Text("Lukas Grimm") }
                LabeledContent("Version") { Text(version) }
                Button(action: { url = AboutScreen.gitHubURL }) {
                    Text("Source Code")
                }g
            }
            
            Section {
                Button(action: { url = AboutScreen.privacyStatementURL }) {
                    Text("Privacy Statement")
                }
                NavigationLink("Third Party Software", destination: ThirdPartySoftwareScreen())
            }
        }
        .sheet(item: $url) { url in
            SafariView(url: url)
        }
        .navigationTitle(Text("About"))
    }
}

#Preview {
    NavigationStack {
        AboutScreen()
    }
}
