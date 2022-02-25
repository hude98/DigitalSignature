//
//  DigitalSignConfigValue.swift
//  Digital Signature
//
//  Created by Tran Tien Anh on 25/02/2022.
//

import Foundation
import PreferencesKit

let digitalSignConfig: AppPreferences<DigitalSignConfigValue> = .init(userDefaults: EnvironmentValues.sharedDefaults)

struct DigitalSignConfigValue: AppPreferenceValues {
    let SimPkiConfig: SimPKIConfig? = nil

    static func keyRaw<T>(for keyPath: KeyPath<DigitalSignConfigValue, T>) -> String {
        switch keyPath {
        case \Self.SimPkiConfig:
            return "bf090b23-f99f-48bd-8117-a9d9a0a2923a"

        default:
            assert(false, "Unable to find key with associated keyPath: \(keyPath)")
            return ""
        }
    }

    static func defaultValues() -> DigitalSignConfigValue {
        return .init()
    }
}

struct SimPKIConfig: Codable {
    let value: String
    let name: String
    let id: String
}
