//
//  SimPKIModel.swift
//  Digital Signature
//
//  Created by Tran Tien Anh on 19/02/2022.
//

import Foundation

struct SimPKIModel: ServiceProviderModel {
    let id: Int
    let name: String
    let status: Int
    let createdDate: String
    let lastModifiedDate: String
    let totalRow: Int
}

struct ServiceProviderSimPKI: Codable {
    let data: [SimPKIModel]
}
