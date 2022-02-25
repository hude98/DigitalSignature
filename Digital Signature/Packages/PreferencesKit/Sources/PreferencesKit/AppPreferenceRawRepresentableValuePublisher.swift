//
//  AppPreferenceRawRepresentableValuePublisher.swift
//  macOS-SwiftUI
//
//  Created by Peter Vu on 4/20/20.
//  Copyright © 2020 Peter Vu. All rights reserved.
//

import Combine
import Foundation

struct AppPreferenceRawRepresentableValuePublisher<Value: RawRepresentable>: Publisher where Value.RawValue: UserDefaultValue {
    typealias Output = Value
    typealias Failure = Never

    let keyRaw: String
    let options: NSKeyValueObservingOptions
    let userDefaults: UserDefaults
    let defaultValue: Value

    func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = RawRepresentableValueSubscription(keyRaw: keyRaw,
                                                             defaultValue: defaultValue,
                                                             options: options,
                                                             userDefaults: userDefaults,
                                                             subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

private final class RawRepresentableValueSubscription<SubscriberType: Subscriber,
                                                      Value: RawRepresentable>: NSObject, Subscription
                                                      where Value.RawValue: UserDefaultValue,
                                                            SubscriberType.Input == Value,
                                                            SubscriberType.Failure == Never {
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
        guard let rawValue = change?[.newKey] as? Value.RawValue else {
            _ = subscriber.receive(defaultValue)
            return
        }

        let convertedValue = Value(rawValue: rawValue) ?? defaultValue
        _ = subscriber.receive(convertedValue)
    }

    func request(_ demand: Subscribers.Demand) { }

    func cancel() {
        userDefaults.removeObserver(self, forKeyPath: keyRaw)
    }
}
