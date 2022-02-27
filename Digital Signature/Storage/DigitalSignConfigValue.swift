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
    let simPkiConfig: SimPKIConfig? = nil
    let remoteSigningConfig: RemoteSigningConfig? = nil
    let tsaConfig: TSAConfig_? = nil
    
    static func keyRaw<T>(for keyPath: KeyPath<DigitalSignConfigValue, T>) -> String {
        switch keyPath {
        case \Self.simPkiConfig:
            return "bf090b23-f99f-48bd-8117-a9d9a0a2923a"
        case \Self.remoteSigningConfig:
            return "5148939a-96db-11ec-b909-0242ac120002"
        case \Self.tsaConfig:
            return "bd60df92-96db-11ec-b909-0242ac120002"
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

struct RemoteSigningConfig: Codable {
    let value: String
    let name: String
    let id: String
}

struct TSAConfig_: Codable {
    let value: String
    let name: String
    let id: String
}
