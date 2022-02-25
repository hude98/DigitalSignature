//
//  SigningModel.swift
//  Digital Signature
//
//  Created by Ta Huy Hung on 25/02/2022.
//

import Foundation

struct SigningModel: Codable {
    let signType: String
    let providerId: String
    let hashAlg: String
    let x509CerificateBase64: String
    let fileInfo: FileInfo
    let signTSA: Bool
    let tSAConfig: TSAConfig
    let signSimPKIConfig: SignSimPKIConfig
    let signRemoteSigningConfig: SignRemoteSigningConfig
    let pDFSignatureSetting: PDFSignatureSetting
}

struct FileInfo: Codable {
    let extensionFile: String
    let fileName: String
    let dataBase64: String
}

struct TSAConfig: Codable {
    let providerId: String
    let url: String
    let username: String
    let password: String
}

struct SignSimPKIConfig: Codable {
    let mobile: String
    let dataToBeDisplayed: String
}

struct SignRemoteSigningConfig: Codable {
    let credentialId: String
    let refreshToken: String
}

struct PDFSignatureSetting: Codable {
    let visible: Bool
    let customText: String
    let sigX,sigY,sigW,sigH: Float
    let page: Int
    let positionSignature: String
    let showLogo: String
    let logoBase64: String
    let showLabel: Bool
    let showEmail: Bool
    let showUnit: Bool
    let showSignTime: Bool
    let showPosition: Bool
    let position: String
}
