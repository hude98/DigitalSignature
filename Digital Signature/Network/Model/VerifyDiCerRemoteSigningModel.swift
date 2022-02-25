//
//  VerifyDiCerRemoteSigning.swift
//  Digital Signature
//
//  Created by Ta Huy Hung on 23/02/2022.
//

import Foundation

// MARK: - VerifyDiCerRemoteSigningModel
struct VerifyDiCerRemoteSigningModel: Codable {
    let value: Result
    let isSuccess: Bool
    let propertyErrors: [String]
    let isValid: Bool
    let message: String?
}

// MARK: - Result
struct Result: Codable {
    let deviceId, accessToken, refreshToken: String
    let certs: ListCerts
}

// MARK: - ListCerts
struct ListCerts: Codable {
    let credentialId: String
    let credentialInfo: CredentialInfo
    let issuerDN: String
    let validFrom: String
    let validTo: String
    let status: String
}

// MARK: - CredentialInfo
struct CredentialInfo: Codable{
    let serialNumber: String
    let certificates: [String]
}
