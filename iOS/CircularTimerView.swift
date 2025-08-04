//
//  CircularTimerView.swift
//  OTPVault
//
//  Created by Lukas Grimm on 26.07.25.
//

import SwiftUI

struct CircularTimerView: View {
    let totalTime: Double = 30.0
    
    var body: some View {
        TimelineView(.animation) { context in
            let elapsed = context.date.timeIntervalSince1970
            let remaining = totalTime - (elapsed.truncatingRemainder(dividingBy: 30))
            let progress = remaining / totalTime
            
            let color = remaining < 5 ? Color.red : remaining < 10 ? .yellow : .blue
            
            ZStack {
                Text("\(Int(remaining))")
                    .font(.system(size: 10))
                    .foregroundStyle(color)
                    .accessibilityLabel("Remaining time: \(Int(remaining)) seconds")
                Circle()
                    .trim(from: 1 - progress, to: 1)
                    .rotation(Angle(degrees: 270))
                    .stroke(lineWidth: 2)
                    .foregroundStyle(color)
                    .accessibilityHidden(true)
            }
            .frame(width: 20, height: 20)
        }
    }
}

#Preview {
    CircularTimerView()
}
