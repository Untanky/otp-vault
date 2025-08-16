//
//  ScannerView.swift
//  OTPVault
//
//  Created by Lukas Grimm on 11.07.25.
//

import CodeScanner
import SwiftUI

struct ScannerView: View {
    let scannedOneTimePassword: (OneTimePassword) -> Void
    @State private var error: Error?
    
    var body: some View {
        ZStack {
            CodeScannerView(
                codeTypes: [.qr],
                showViewfinder: true,
                completion: handleScanResult
            )
            .ignoresSafeArea(edges: .bottom)
            
            VStack {
                Text("Scan QR code")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Material.regular, in: RoundedRectangle(cornerRadius: 12))
                    .padding(.top, 60)
                
                if let error = error {
                    HStack(alignment: .top) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                        Text(error.localizedDescription)
                            .foregroundColor(.red)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Material.regular, in: RoundedRectangle(cornerRadius: 12))
                    .frame(maxWidth: 300)
                    
                }
                
                Spacer()
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
    
    private func handleScanResult(_ scanResult: Result<ScanResult, ScanError>) {
        switch scanResult {
        case .failure(let error):
            self.error = error
        case .success(let result):
            guard let uri = URL(string: result.string) else {
                self.error = NSError(domain: "Invalid URI", code: 0, userInfo: nil)
                return
            }
            let otpResult = OneTimePassword.parseUri(uri)
            switch otpResult {
            case .failure(let error):
                self.error = error
            case .success(let item):
                scannedOneTimePassword(item)
            }
        }
    }
}
