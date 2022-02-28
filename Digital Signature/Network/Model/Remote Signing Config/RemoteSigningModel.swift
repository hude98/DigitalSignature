//
//  RemoteSigningModel.swift
//  Digital Signature
//
//  Created by Ta Huy Hung on 23/02/2022.
//

import Foundation

struct RemoteSigningModel: ServiceProviderModel {
    let id: Int
    let name: String
    let status: Int
    let createdDate: String
    let lastModifiedDate: String
    let totalRow: Int
}

struct ServiceProviderRemoteSigning: Codable {
    let data: [RemoteSigningModel]
}

// MARK: - Remote Signing Response Model
struct RemoteSigningResponseModel: Codable {
    let value: ValueSigningResponseModel?
    let isSuccess: Bool
    let message: String?
    let propertyErrors: [String]
    let resultCode: Int
    let isValid: Bool
}

// MARK: - Value
struct ValueSigningResponseModel: Codable {
    let deviceID, accessToken, refreshToken: String
    let certs: [CERT]
}

// MARK: - CERT
struct CERT: Codable {
    let credentialID: String
    let credentialInfo: CredentialInfoRemoteSigning
}

// MARK: - CredentialInfo
struct CredentialInfoRemoteSigning: Codable {
    let serialNumber: String
    let certificates: [String]
    let issuerDN, validFrom, validTo, status: String
    let subjectDN: String
}
