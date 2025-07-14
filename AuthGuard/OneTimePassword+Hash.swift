//
//  OneTimePassword.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 10.07.25.
//

import Foundation

fileprivate func hmacSha1(_ key: Data, _ data: Data) -> Data {
    var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        
    key.withUnsafeBytes { keyBytes in
        data.withUnsafeBytes { messageBytes in
            CCHmac(
                CCHmacAlgorithm(kCCHmacAlgSHA1),
                keyBytes.baseAddress,
                key.count,
                messageBytes.baseAddress,
                data.count,
                &digest
            )
        }
    }
    
    return Data(digest)
}

fileprivate func formatHotp(_ otp: UInt32) -> String {
    return String(format: "%06u", otp)
}

func generateHotp(_ secret: Data, _ count: Int) -> String {
    let hash = hmacSha1(secret, withUnsafeBytes(of: count) { Data($0) })
    let offset = Int(hash.last! & 0b1111)
    
    let range = offset..<(offset + 4)
    let relevantBytes = hash.subdata(in: range)
    
    let tmp = relevantBytes.withUnsafeBytes { ptr -> UInt32 in
        return ptr.load(as: UInt32.self).littleEndian
    }
    return formatHotp(tmp % 1_000_000)
}
