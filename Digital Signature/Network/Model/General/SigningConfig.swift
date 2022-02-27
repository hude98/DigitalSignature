//
//  DigitalCertInfo.swift
//  Digital Signature
//
//  Created by Ta Huy Hung on 27/02/2022.
//

import Foundation

struct SigningConfig: Codable{
    let statusMessage: String?
    let certificateInfo: [String]?
    let signType: String?
    let providerId: String?
    let cerBase64: String?
}

struct DigitalConfigName{
    static let SimPKI = "SimPKI"
    static let RemoteSigning = "RemoteSigning"
}
