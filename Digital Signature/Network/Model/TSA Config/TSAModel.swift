//
//  TSAModel.swift
//  Digital Signature
//
//  Created by Ta Huy Hung on 23/02/2022.
//

import Foundation

struct TSAModel: ServiceProviderModel {
    let id: Int
    let name: String
    let status: Int
    let createdDate: String
    let lastModifiedDate: String
    let totalRow: Int
}

struct ServiceProviderTSA: Codable {
    let data: [TSAModel]
}
