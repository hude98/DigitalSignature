//
//  DeviceInfo.swift
//  Digital Signature
//
//  Created by Ta Huy Hung on 23/02/2022.
//

import Foundation

struct DeviceInfo: Codable {
    var OS: String
    var deviceName: String
    var sic_id: String
    var type: String
    var model: String
    var version: String
    var serial: String
}
