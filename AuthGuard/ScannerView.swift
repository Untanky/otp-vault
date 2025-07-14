//
//  ScannerView.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 11.07.25.
//

import CodeScanner
import SwiftUI

struct ScannerView: View {
    @Binding var path: NavigationPath
    
    var body: some View {
        CodeScannerView(
            codeTypes: [.qr],
            completion: handleScanResult
        )
        .ignoresSafeArea(edges: .bottom)
    }
    
    private func handleScanResult(_ scanResult: Result<ScanResult, ScanError>) {
        switch scanResult {
        case .failure(let error):
            print("Error: \(error)")
        case .success(let result):
            guard let uri = URL(string: result.string) else {
                return
            }
            let otpResult = OneTimePassword.parseUri(uri)
            switch otpResult {
            case .failure(let error):
                print("Error: \(error)")
            case .success(let item):
                path.append(Route.oneTimePasswordDetails(item: item))
            }
        }
    }
}
