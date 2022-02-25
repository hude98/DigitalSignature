//
//  AppPreferences.swift
//  Habitify
//
//  Created by Peter Vu on 4/16/20.
//  Copyright © 2020 Peter Vu. All rights reserved.
//

import Combine
import Foundation

public protocol AppPreferenceValues {
    static func keyRaw<T>(for keyPath: KeyPath<Self, T>) -> String
    static func defaultValues() -> Self
}

@dynamicMemberLookup
public class AppPreferences<Values: AppPreferenceValues> {
    public let userDefaults: UserDefaults

    public let defaultEncoder = JSONEncoder()
    public let defaultDecoder = JSONDecoder()

    public let defaultValues = Values.defaultValues()

    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    public subscript<T: UserDefaultValue>(dynamicMember keyPath: KeyPath<Values, T>) -> T {
        get {
            let keyRaw = Values.keyRaw(for: keyPath)
            return (userDefaults.object(forKey: keyRaw) as? T) ?? defaultValues[keyPath: keyPath]
        } set {
            let keyRaw = Values.keyRaw(for: keyPath)
            userDefaults.set(newValue, forKey: keyRaw)
        }
    }

    public subscript<T: UserDefaultValue>(dynamicMember keyPath: KeyPath<Values, T?>) -> T? {
        get {
            let keyRaw = Values.keyRaw(for: keyPath)
            return userDefaults.object(forKey: keyRaw) as? T
        } set {
            let keyRaw = Values.keyRaw(for: keyPath)
            switch newValue {
            case .none:
                userDefaults.removeObject(forKey: keyRaw)

            case .some(let value):
                userDefaults.set(value, forKey: keyRaw)
            }
        }
    }

    public subscript<T: RawRepresentable>(dynamicMember keyPath: KeyPath<Values, T>) -> T where T.RawValue: UserDefaultValue {
        get {
            return rawRepresentableValue(for: keyPath)
        } set {
            setRawRepresentableValue(newValue, for: keyPath)
        }
    }

    public func decodableValue<T: Decodable, Decoder: TopLevelDecoder>(for keyPath: KeyPath<Values, T>,
                                                                       with decoder: Decoder) -> T where Decoder.Input == Data {
        let keyRaw = Values.keyRaw(for: keyPath)
        guard let rawData = userDefaults.data(forKey: keyRaw), !rawData.isEmpty else {
            return defaultValues[keyPath: keyPath]
        }

        do {
            return try decoder.decode(T.self, from: rawData)
        } catch {
            debugPrint("Unable to decode value of \(T.self) error: \(error.localizedDescription)")
            return defaultValues[keyPath: keyPath]
        }
    }

    public func decodableValue<T: Decodable>(for keyPath: KeyPath<Values, T>) -> T {
        return decodableValue(for: keyPath, with: defaultDecoder)
    }

    public func rawRepresentableValue<T: RawRepresentable>(for keyPath: KeyPath<Values, T>) -> T where T.RawValue: UserDefaultValue {
        let keyRaw = Values.keyRaw(for: keyPath)
        guard let rawValue = userDefaults.object(forKey: keyRaw) as? T.RawValue else {
            return defaultValues[keyPath: keyPath]
        }
        return T(rawValue: rawValue) ?? defaultValues[keyPath: keyPath]
    }

    public func defaultValue<T>(for keyPath: KeyPath<Values, T>) -> T {
        return defaultValues[keyPath: keyPath]
    }

    public func defaultValue<T>(for keyPath: ReferenceWritableKeyPath<Values, T>) -> T {
        return defaultValues[keyPath: keyPath]
    }

    public func setRawRepresentableValue<T: RawRepresentable>(_ value: T,
                                                              for keyPath: KeyPath<Values, T>) where T.RawValue: UserDefaultValue {
        let keyRaw = Values.keyRaw(for: keyPath)
        userDefaults.set(value.rawValue, forKey: keyRaw)
    }

    public func setEncodableValue<T: Encodable, Encoder: TopLevelEncoder>(_ value: T?,
                                                                          with encoder: Encoder,
                                                                          for keyPath: KeyPath<Values, T>) throws where Encoder.Output == Data {
        let keyRaw = Values.keyRaw(for: keyPath)
        if let wrappedValue = value {
            let encodedValue = try encoder.encode(wrappedValue)
            userDefaults.set(encodedValue, forKey: keyRaw)
        } else {
            userDefaults.removeObject(forKey: keyRaw)
        }
    }

    public func setEncodableValue<T: Encodable>(_ value: T?, for keyPath: KeyPath<Values, T>) throws {
        try setEncodableValue(value, with: defaultEncoder, for: keyPath)
    }

    public func removeValue<T>(for keyPath: KeyPath<Values, T>) {
        let keyRaw = Values.keyRaw(for: keyPath)
        userDefaults.removeObject(forKey: keyRaw)
    }
}
