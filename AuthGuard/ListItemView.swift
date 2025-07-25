//
//  ListItem.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 10.07.25.
//

import SwiftUI

struct CircularTimerView: View {
    let totalTime: Double = 30.0
    let startDate = Date()
    
    var body: some View {
        TimelineView(.animation) { context in
            let elapsed = context.date.timeIntervalSince1970
            let remaining = totalTime - (elapsed.truncatingRemainder(dividingBy: 30))
            let progress = remaining / totalTime
            
            let color = remaining < 5 ? Color.red : remaining < 10 ? .yellow : .blue
            
            ZStack {
                Text("\(Int(remaining))")
                    .font(.system(size: 10))
                    .tint(color)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(lineWidth: 2)
                    .foregroundColor(color)
            }
            .frame(width: 20, height: 20)
        }
    }
}

struct ListItemView: View {
    @State private var showingCopied = false
    @State private var isAnimating = false
    
    private static let codeFont = Font.system(size: 24, weight: .bold, design: .monospaced)
    
    let oneTimePassword: OneTimePassword
    
    let onClickCode: (String) -> Void
    
    @State var timerId: TimerId?
    
    @State private var code: String
    
    init(item: OneTimePassword, onClickCode: @escaping (String) -> Void) {
        self.oneTimePassword = item
        
        self.onClickCode = onClickCode
        
        self.code = item.generateTotp()
    }
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(oneTimePassword.label)
                Text(oneTimePassword.account)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button(action: {
                guard !isAnimating else { return }
                isAnimating = true
                withAnimation(.spring()) {
                    showingCopied = true
                }
                // Hide "COPIED" after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.spring()) {
                        showingCopied = false
                    }
                    // Allow another animation after transition completes
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isAnimating = false
                    }
                }
                
                onClickCode(code)
            }) {
                HStack {
                    CircularTimerView()
                    ZStack {
                        Text("COPIED")
                            .font(ListItemView.codeFont)
                            .foregroundColor(.green)
                            .opacity(showingCopied ? 1 : 0)
                            .offset(y: showingCopied ? 0 :45)
                            .id("copied")
                        Text(code)
                            .font(ListItemView.codeFont)
                            .foregroundColor(.blue)
                            .opacity(showingCopied ? 0 : 1)
                            .offset(y: showingCopied ? -45 : 0)
                            .id("code")
                    }
                }
            }
            .animation(.spring(), value: showingCopied)
        }
        .onAppear {
            self.timerId = TimerService.shared.register(forInterval: oneTimePassword.period, callback: {
                self.code = oneTimePassword.generateTotp()
            })
        }
        .onDisappear {
            guard let timerId else { return }
            TimerService.shared.unregister(id: timerId)
            self.timerId = nil
        }
    }
}

#Preview {
    ListItemView(item: OneTimePassword(label: "Platform", issuer: "Issuer", account: "Account 1", secret: "a".data(using: .utf8)!, period: TimeInterval(30), digits: 6, algorithm: .sha1), onClickCode: { code in print("Hello World") })
}
