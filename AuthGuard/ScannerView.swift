//
//  ScannerView.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 11.07.25.
//

import CodeScanner
import SwiftUI

struct ScannerView: View {
    var body: some View {
        CodeScannerView(
            codeTypes: [.qr],
            completion: handleScanResult
        )
        .ignoresSafeArea(edges: .bottom)
    }
    
    private func handleScanResult(_ result: Result<ScanResult, ScanError>) {
        
    }
}
