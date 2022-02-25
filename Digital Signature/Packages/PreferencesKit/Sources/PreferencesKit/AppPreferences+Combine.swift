//
//  AppPreferences+Combine.swift
//  Habitify
//
//  Created by Peter Vu on 5/26/20.
//  Copyright © 2020 Peter Vu. All rights reserved.
//

import Combine
import Foundation

public extension AppPreferences {
    func publisher<T: UserDefaultValue>(for keyPath: KeyPath<Values, T>,
                                        options: NSKeyValueObservingOptions = [.new, .old]) -> AnyPublisher<T, Never> {
        return makePublisher(for: keyPath, options: options)
    }
    
    func publisher<T: UserDefaultValue>(for keyPath: KeyPath<Values, T>,
                                        options: NSKeyValueObservingOptions = [.new, .old]) -> AnyPublisher<T, Never> where T: Equatable {
        return makePublisher(for: keyPath, options: options)
                    .removeDuplicates()
                    .eraseToAnyPublisher()
    }
    
    private func makePublisher<T: UserDefaultValue>(for keyPath: KeyPath<Values, T>,
                                                    options: NSKeyValueObservingOptions = [.new, .old]) -> AnyPublisher<T, Never> {
        let currentValueSubject = Just<T>(self[dynamicMember: keyPath])
        let changePublisher = AppPreferenceValuePublisher<T>(keyRaw: Values.keyRaw(for: keyPath),
                                                             options: options,
                                                             userDefaults: userDefaults,
                                                             defaultValue: defaultValues[keyPath: keyPath])
        return Publishers.Merge(currentValueSubject, changePublisher).eraseToAnyPublisher()
    }
    
    // Decodable Support
    func decodablePublisher<T: Decodable, Decoder: TopLevelDecoder>(for keyPath: KeyPath<Values, T>,
                                                                    with decoder: Decoder,
                                                                    options: NSKeyValueObservingOptions = [.new, .old]) -> AnyPublisher<T, Never> where Decoder.Input == Data {
        return makeDecodablePublisher(for: keyPath, with: decoder, options: options)
    }
    
    func decodablePublisher<T: Decodable, Decoder: TopLevelDecoder>(for keyPath: KeyPath<Values, T>,
                                                                    with decoder: Decoder,
                                                                    options: NSKeyValueObservingOptions = [.new, .old]) -> AnyPublisher<T, Never> where Decoder.Input == Data, T: Equatable {
        return makeDecodablePublisher(for: keyPath, with: decoder, options: options)
                    .removeDuplicates()
                    .eraseToAnyPublisher()
    }

    func decodablePublisher<T: Decodable>(for keyPath: KeyPath<Values, T>,
                                          options: NSKeyValueObservingOptions = [.new, .old]) -> AnyPublisher<T, Never> {
        return makeDecodablePublisher(for: keyPath, with: defaultDecoder, options: options)
    }
    
    func decodablePublisher<T: Decodable>(for keyPath: KeyPath<Values, T>,
                                          options: NSKeyValueObservingOptions = [.new, .old]) -> AnyPublisher<T, Never> where T: Equatable {
        return makeDecodablePublisher(for: keyPath, with: defaultDecoder, options: options)
                    .removeDuplicates()
                    .eraseToAnyPublisher()
    }
    
    private func makeDecodablePublisher<T: Decodable, Decoder: TopLevelDecoder>(for keyPath: KeyPath<Values, T>,
                                                                                with decoder: Decoder,
                                                                                options: NSKeyValueObservingOptions = [.new, .old]) -> AnyPublisher<T, Never> where Decoder.Input == Data {
        let currentValueSubject = Just<T>(self.decodableValue(for: keyPath, with: decoder))
        let changePublisher = AppPreferenceDecodableValuePublisher(keyRaw: Values.keyRaw(for: keyPath),
                                                                   options: options,
                                                                   decoder: decoder,
                                                                   userDefaults: userDefaults,
                                                                   defaultValue: defaultValues[keyPath: keyPath])
        return Publishers
                    .Merge(currentValueSubject, changePublisher)
                    .eraseToAnyPublisher()
    }

    // RawRepresentable Support
    func rawRepresentablePublisher<T: RawRepresentable>(for keyPath: KeyPath<Values, T>,
                                                        options: NSKeyValueObservingOptions = [.new, .old]) -> AnyPublisher<T, Never> where T.RawValue: UserDefaultValue {
        return makeRawRepresentablePublisher(for: keyPath, options: options)
    }
    
    func rawRepresentablePublisher<T: RawRepresentable>(for keyPath: KeyPath<Values, T>,
                                                        options: NSKeyValueObservingOptions = [.new, .old]) -> AnyPublisher<T, Never> where T.RawValue: UserDefaultValue, T: Equatable {
        return makeRawRepresentablePublisher(for: keyPath, options: options)
                    .removeDuplicates()
                    .eraseToAnyPublisher()
    }
    
    private func makeRawRepresentablePublisher<T: RawRepresentable>(for keyPath: KeyPath<Values, T>,
                                                                    options: NSKeyValueObservingOptions = [.new, .old]) -> AnyPublisher<T, Never> where T.RawValue: UserDefaultValue {
        let currentValueSubject = Just<T>(self.rawRepresentableValue(for: keyPath))
        let changePublisher = AppPreferenceRawRepresentableValuePublisher(keyRaw: Values.keyRaw(for: keyPath),
                                                                          options: options,
                                                                          userDefaults: userDefaults,
                                                                          defaultValue: defaultValues[keyPath: keyPath])
        return Publishers
                    .Merge(currentValueSubject, changePublisher)
                    .eraseToAnyPublisher()
    }
}
