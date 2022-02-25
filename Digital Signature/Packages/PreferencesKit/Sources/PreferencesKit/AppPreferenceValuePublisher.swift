//
//  AppPreferenceValuePublisher.swift
//  Habitify
//
//  Created by Peter Vu on 4/16/20.
//  Copyright © 2020 Peter Vu. All rights reserved.
//

import Combine
import Foundation

public struct AppPreferenceValuePublisher<T: UserDefaultValue>: Publisher {
    public typealias Output = T
    public typealias Failure = Never

    public let keyRaw: String
    public let options: NSKeyValueObservingOptions
    public let userDefaults: UserDefaults
    public let defaultValue: T
    
    public init(keyRaw: String, options: NSKeyValueObservingOptions, userDefaults: UserDefaults, defaultValue: T) {
        self.keyRaw = keyRaw
        self.options = options
        self.userDefaults = userDefaults
        self.defaultValue = defaultValue
    }

    public func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = UserDefaultsValueSubscription(keyRaw: keyRaw,
                                                         defaultValue: defaultValue,
                                                         options: options,
                                                         userDefaults: userDefaults,
                                                         subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

private class UserDefaultsValueSubscription<SubscriberType: Subscriber, Value: UserDefaultValue>: NSObject, Subscription where SubscriberType.Input == Value, SubscriberType.Failure == Never {
    private let defaultValue: Value
    private let keyRaw: String
    private let options: NSKeyValueObservingOptions
    private let userDefaults: UserDefaults
    private var subscriber: SubscriberType

    init(keyRaw: String,
         defaultValue: Value,
         options: NSKeyValueObservingOptions,
         userDefaults: UserDefaults,
         subscriber: SubscriberType) {
        self.keyRaw = keyRaw
        self.options = options
        self.userDefaults = userDefaults
        self.subscriber = subscriber
        self.defaultValue = defaultValue
        super.init()
        self.userDefaults.addObserver(self, forKeyPath: keyRaw, options: options, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?) {
        guard keyPath == keyRaw else {
            return
        }
        guard let otherDefaults = object as? UserDefaults, otherDefaults == userDefaults else {
            return
        }
        let newValue = (change?[.newKey] as? Value) ?? defaultValue
        _ = subscriber.receive(newValue)
    }

    func request(_ demand: Subscribers.Demand) {
    }

    func cancel() {
        userDefaults.removeObserver(self, forKeyPath: keyRaw)
    }
}

extension UserDefaults {
    func publisher<T: UserDefaultValue>(for key: String,
                                        options: NSKeyValueObservingOptions = [.new, .old],
                                        defaultValue: T) -> AnyPublisher<T, Never> {
        return makePublisher(for: key, defaultValue: defaultValue)
    }
    
    func publisher<T: UserDefaultValue>(for key: String,
                                        options: NSKeyValueObservingOptions = [.new, .old],
                                        defaultValue: T) -> AnyPublisher<T, Never> where T: Equatable {
        return makePublisher(for: key, defaultValue: defaultValue)
                    .removeDuplicates()
                    .eraseToAnyPublisher()
    }
    
    private func makePublisher<T: UserDefaultValue>(for key: String,
                                                    options: NSKeyValueObservingOptions = [.new, .old],
                                                    defaultValue: T) -> AnyPublisher<T, Never> {
         let currentValue = object(forKey: key) as? T ?? defaultValue
         let currentValueSubject = Just<T>(currentValue)
         let changePublisher = AppPreferenceValuePublisher<T>(keyRaw: key,
                                                              options: options,
                                                              userDefaults: self,
                                                              defaultValue: defaultValue)
         return Publishers
                    .Merge(currentValueSubject, changePublisher)
                    .eraseToAnyPublisher()
     }
}
