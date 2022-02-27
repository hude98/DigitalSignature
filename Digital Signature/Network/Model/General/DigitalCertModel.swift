//
//  DigitalCertModel.swift
//  Digital Signature
//
//  Created by Ta Huy Hung on 27/02/2022.
//

import Foundation

protocol DigitalCertModel: Codable {
    var id: Int { get }
    var name: String { get }
}
