//
//  AppPreferenceDecodableValuePublisher.swift
//  macOS-SwiftUI
//
//  Created by Peter Vu on 4/19/20.
//  Copyright © 2020 Peter Vu. All rights reserved.
//

import Combine
import Foundation

struct AppPreferenceDecodableValuePublisher<Value: Decodable, Decoder: TopLevelDecoder>: Publisher where Decoder.Input == Data {
    typealias Output = Value
    typealias Failure = Never

    let keyRaw: String
    let options: NSKeyValueObservingOptions
    let decoder: Decoder
    let userDefaults: UserDefaults
    let defaultValue: Value

    func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = DecodableValueSubscription(keyRaw: keyRaw,
                                                      defaultValue: defaultValue,
                                                      decoder: decoder,
                                                      options: options,
                                                      userDefaults: userDefaults,
                                                      subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

private final class DecodableValueSubscription<SubscriberType: Subscriber,
                                               Value: Decodable,
                                               Decoder: TopLevelDecoder>: NSObject, Subscription where SubscriberType.Input == Value,
                                                                                                 SubscriberType.Failure == Never,
                                                                                                 Decoder.Input == Data {
    private let defaultValue: Value
    private let keyRaw: String
    private let options: NSKeyValueObservingOptions
    private let userDefaults: UserDefaults
    private let decoder: Decoder
    private var subscriber: SubscriberType

    init(keyRaw: String,
         defaultValue: Value,
         decoder: Decoder,
         options: NSKeyValueObservingOptions,
         userDefaults: UserDefaults,
         subscriber: SubscriberType) {
        self.keyRaw = keyRaw
        self.options = options
        self.userDefaults = userDefaults
        self.subscriber = subscriber
        self.decoder = decoder
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
        
        guard let newData = change?[.newKey] as? Decoder.Input, !newData.isEmpty else {
            _ = subscriber.receive(defaultValue)
            return
        }

        do {
            let decodedValue = try decoder.decode(Value.self, from: newData)
            _ = subscriber.receive(decodedValue)
        } catch {
            _ = subscriber.receive(defaultValue)
        }
    }

    func request(_ demand: Subscribers.Demand) {
    }

    func cancel() {
        userDefaults.removeObserver(self, forKeyPath: keyRaw)
    }
}
