//
//  FullScreenCoverView.swift
//  OTPVault
//
//  Created by Lukas Grimm on 07.08.25.
//


import SwiftUI

struct FullScreenCoverView<Content: View>: View {
    let isPresented: Bool
    let content: () -> Content
    
    var body: some View {
        ZStack {
            if isPresented {
                Color.black
                    .ignoresSafeArea(edges: .all)
                    .overlay {
                        content()
                    }
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom),
                        removal: .scale(scale: 2, anchor: .init(x: 0.5, y: 0.25)).combined(with: .opacity))
                    )
            }
        }
        .animation(.easeInOut(duration: 0.35), value: isPresented)
    }
}