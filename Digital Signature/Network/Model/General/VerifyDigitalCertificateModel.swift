//
//  VerifyDigitalCertificateModel.swift
//  Digital Signature
//
//  Created by Tran Tien Anh on 20/02/2022.
//

import Foundation

struct VerifyDigitalCertificateModel: Codable {
    let value: Value
    let isSuccess: Bool
    let message: String?
    let propertyErrors: [String]
    let resultCode: Int
    let isValid: Bool
}

// MARK: - Value
struct Value: Codable {
    let statusCode, statusMessage, subject: String
    let certificateInfo: [String]
    let transaction: Transaction?
    let providerID: String?
}

// MARK: - Transaction
struct Transaction: Codable {
    let transactionID, transactionType, transactionSubType: String
    let createdDateTime, status: String
    let isSignOffline: Int
    let cerSerialSign, certificate, ocspCheckResult, cerCheckResult: String
    let purpose: String
    let createdBy: Int
    let totalRow: Int

 
}
