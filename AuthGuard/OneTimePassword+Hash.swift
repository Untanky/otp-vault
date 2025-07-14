//
//  OneTimePassword+Hash.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 10.07.25.
//

import CryptoKit
import Foundation

extension OneTimePassword {
    func generateTotp() -> String {
        return generateHotp(Int(Date().timeIntervalSince1970) / Int(self.period))
    }
    
    fileprivate static let digitDivider: [Int:UInt32] = [6:1_000_000, 7:10_000_000, 8:100_000_000]
    
    func generateHotp(_ count: Int) -> String {
        let hash = self.getHash(withUnsafeBytes(of: count.bigEndian) { Data($0) })
        let offset = Int(hash.last! & 0b1111)
        
        let offsetValue: UInt32 = (UInt32((hash[offset]) & 0x7f) << 24) |
                     ((UInt32(hash[offset + 1]) & 0xff) << 16) |
                     ((UInt32(hash[offset + 2]) & 0xff) << 8) |
                     (UInt32(hash[offset + 3]) & 0xff);
        return formatHotp(offsetValue % OneTimePassword.digitDivider[self.digits]!)
    }
    
    private func getHash(_ data: Data) -> Data {
        switch algorithm {
        case .sha1:
            return self.hmacSha1(data)
        case .sha256:
            var hasher = SHA256()
            hasher.update(data: self.secret)
            hasher.update(data: data)
            
            let digest = hasher.finalize()
            return digest.withUnsafeBytes { Data($0) }
        case .sha512:
            var hasher = SHA512()
            hasher.update(data: self.secret)
            hasher.update(data: data)
            
            let digest = hasher.finalize()
            return digest.withUnsafeBytes { Data($0) }
        }
    }
    
    private func hmacSha1(_ count: Data) -> Data {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
            
        self.secret.withUnsafeBytes { unsafeSecrets in
            count.withUnsafeBytes { unsafeCount in
                CCHmac(
                    CCHmacAlgorithm(kCCHmacAlgSHA1),
                    unsafeSecrets.baseAddress,
                    self.secret.count,
                    unsafeCount.baseAddress,
                    count.count,
                    &digest
                )
            }
        }
        
        return Data(digest)
    }
    
    private func formatHotp(_ otp: UInt32) -> String {
        return String(format: "%06u", otp)
    }
}
