//
//  Base32DecodeTests.swift
//  AuthGuard
//
//  Created by Lukas Grimm on 14.07.25.
//

import Testing
@testable import AuthGuard

struct Base32DecodeTests {

    @Test func decodeBase32StringCorrectly() async throws {
        let expected = "Hello World".data(using: .utf8)
        let input = "JBSWY3DPEBLW64TMMQ======"
        
        let data = input.base32DecodedData()
        
        #expect(data == expected)
    }

}
