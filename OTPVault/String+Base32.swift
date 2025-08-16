//
//  String.Base32.swift
//  OTPVault
//
//  Created by Lukas Grimm on 14.07.25.
//

import Foundation

extension String {
    func base32DecodedData() -> Data? {
        let base32Alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"
        let base32Chars = Array(self.uppercased())
        var bitBuffer = 0
        var bitCount = 0
        var decodedBytes = [UInt8]()
        
        for char in base32Chars {
            guard let index = base32Alphabet.firstIndex(of: char) else {
                return nil
            }
            let value = base32Alphabet.distance(from: base32Alphabet.startIndex, to: index)
            bitBuffer = (bitBuffer << 5) | value
            bitCount += 5
            
            if bitCount >= 8 {
                bitCount -= 8
                let byte = (bitBuffer >> bitCount) & 0xFF
                decodedBytes.append(UInt8(byte))
            }
        }
        return Data(decodedBytes)
    }
}
