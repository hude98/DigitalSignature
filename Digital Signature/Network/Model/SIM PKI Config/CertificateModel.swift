//
//  CertificateModel.swift
//  Digital Signature
//
//  Created by Tran Tien Anh on 19/02/2022.
//

import Foundation

struct CertificateModel: Decodable {
    var value: String
    var isSuccess: Bool
    var propertyErrors: [String]
    var message: String?
}
