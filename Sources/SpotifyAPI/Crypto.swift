//
//  File.swift
//  
//
//  Created by Ted Bennett on 19/04/2021.
//

import Foundation
import CommonCrypto

func getVerifier() -> String {
    var buffer = [UInt8](repeating: 0, count: 32)
    _ = SecRandomCopyBytes(kSecRandomDefault, buffer.count, &buffer)
    return Data(buffer).base64EncodedString()
        .replacingOccurrences(of: "+", with: "-")
        .replacingOccurrences(of: "/", with: "_")
        .replacingOccurrences(of: "=", with: "")
        .trimmingCharacters(in: .whitespaces)
}
func getChallenge(verifier: String) -> String {
    
    guard let verifierData = verifier.data(using: String.Encoding.utf8) else { return "error" }
    var buffer = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
    
    _ = verifierData.withUnsafeBytes {
        CC_SHA256($0.baseAddress, CC_LONG(verifierData.count), &buffer)
    }
    let hash = Data(buffer)
    print(hash)
    let challenge = hash.base64EncodedData()
    return String(decoding: challenge, as: UTF8.self)
        .replacingOccurrences(of: "+", with: "-")
        .replacingOccurrences(of: "/", with: "_")
        .replacingOccurrences(of: "=", with: "")
        .trimmingCharacters(in: .whitespaces)
}
