//
//  OneTimePasswordEntity.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 15.07.25.
//

import Foundation
import SwiftData

@Model
class OneTimePasswordEntity {
    var id: UUID
    var label: String
    var account: String
    var issuer: String
    var period: Int
    var algorithm: Algorithm
    var digits: Int
    
    init(id: UUID, label: String, account: String, issuer: String, period: Int, algorithm: Algorithm, digits: Int) {
        self.id = id
        self.label = label
        self.account = account
        self.issuer = issuer
        self.period = period
        self.algorithm = algorithm
        self.digits = digits
    }
    
    init(from otp: OneTimePassword) {
        self.id = otp.id
        self.label = otp.label
        self.account = otp.account
        self.issuer = otp.issuer
        self.period = Int(otp.period)
        self.algorithm = otp.algorithm
        self.digits = otp.digits
    }
}
