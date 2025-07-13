//
//  OneTimePasswordItem.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 10.07.25.
//

import Foundation

enum Algorithm: String, Identifiable, CaseIterable, Equatable, Hashable, Codable {
    case sha1 = "SHA-1"
    case sha256 = "SHA-256"
    case sha512 = "SHA-512"
    
    var id: String { rawValue }
}

struct OneTimePasswordItem: Equatable, Hashable, Identifiable {
    let id: UUID = UUID()
    let label: String
    let issuer: String
    let account: String
    let secret: Data
    let period: TimeInterval
    let digits: Int
    let algorithm: Algorithm
}
