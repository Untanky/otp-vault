//
//  OneTimePasswordItem.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 10.07.25.
//

import Foundation

struct OneTimePasswordItem: Equatable, Identifiable {
    let id: UUID = UUID();
    let title: String;
    let account: String;
    let secret: Data;
    let interval: TimeInterval
}
