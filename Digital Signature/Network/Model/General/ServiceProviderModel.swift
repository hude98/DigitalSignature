//
//  ServiceProviderModel.swift
//  Digital Signature
//
//  Created by Ta Huy Hung on 23/02/2022.
//

import Foundation

protocol ServiceProviderModel: Codable {
    var id: Int { get }
    var name: String { get }
}
