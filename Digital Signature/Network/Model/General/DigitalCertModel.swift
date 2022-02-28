//
//  DigitalCertModel.swift
//  Digital Signature
//
//  Created by Ta Huy Hung on 27/02/2022.
//

import Foundation

protocol DigitalCertModel {
    var id: String { get }
    var name: String { get }
    var value: String { get }
    static var type: DigitalCertType { get }
}


enum DigitalCertType: String, Codable {
    case simPKI
    case remoteSigning
    case TSA
}
