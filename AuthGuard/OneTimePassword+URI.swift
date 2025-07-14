//
//  OneTimePassword+URI.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 13.07.25.
//

import Foundation

enum OTPAuthUriError: Error {
    case invalidSchema
    case unsupportedType
    case invalidLabel
    case missingSecret
    case invalidDigits
    case invalidPeriod
    case invalidAlgorithm
    case mismatchedIssuer
    case internalError(_ reason: LocalizedStringResource)
}

extension OneTimePassword {
    
    static func parseUri(_ uri: URL) -> Result<OneTimePassword, OTPAuthUriError> {
        guard let components = URLComponents(url: uri, resolvingAgainstBaseURL: false) else {
            return .failure(.internalError("could not parse url"))
        }
        
        if components.scheme != "otpauth" {
            return .failure(.invalidSchema)
        }
        
        if components.host != "totp" {
            return .failure(.unsupportedType)
        }
        
        let path = uri.pathComponents
        guard path.count == 2 else {
            return .failure(.invalidLabel)
        }
        let label = path[1]
        
        guard let queryItems = components.queryItems else {
            return .failure(.missingSecret)
        }
        let queryMap = Dictionary(uniqueKeysWithValues: queryItems.map { ($0.name, $0.value ?? "") })
        
        guard let secretString = queryMap["secret"], let secret = secretString.base32DecodedData() else {
            return .failure(.missingSecret)
        }
        
        guard let algorithm = Algorithm(rawValue: queryMap["algorithm"] ?? "SHA1") else {
            return .failure(.invalidAlgorithm)
        }
        
        guard let period = Int(queryMap["period"] ?? "30"), [15, 30, 60].contains(period) else {
            return .failure(.invalidPeriod)
        }
        
        guard let digits = Int(queryMap["digits"] ?? "6"), digits >= 6, digits <= 8 else {
            return .failure(.invalidDigits)
        }
        
        let issuer = queryMap["issuer"] ?? ""
        
        guard !label.contains(":") && issuer != label.split(separator: ":").first! else {
            return .failure(.mismatchedIssuer)
        }
        
        return .success(.init(label: label, issuer: issuer, account: label.split(separator: ":").last!.description, secret: secret, period: TimeInterval(period), digits: digits, algorithm: algorithm))
    }
}
