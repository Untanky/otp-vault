//
//  OneTimePassword.swift
//  OTPVault
//
//  Created by Lukas Grimm on 10.07.25.
//

import Foundation

enum Algorithm: String, Identifiable, CaseIterable, Equatable, Hashable, Codable {
    case sha1 = "SHA1"
    case sha256 = "SHA256"
    case sha512 = "SHA512"
    
    var id: String { rawValue }
}

struct OneTimePassword: Equatable, Hashable, Identifiable {
    let id: UUID
    let label: String
    let issuer: String
    let account: String
    let secret: Data
    let period: TimeInterval
    let digits: Int
    let algorithm: Algorithm
    
    init(id: UUID = UUID(), label: String, issuer: String, account: String, secret: Data, period: TimeInterval, digits: Int, algorithm: Algorithm) {
        self.id = id
        self.label = label
        self.issuer = issuer
        self.account = account
        self.secret = secret
        self.period = period
        self.digits = digits
        self.algorithm = algorithm
    }
}
