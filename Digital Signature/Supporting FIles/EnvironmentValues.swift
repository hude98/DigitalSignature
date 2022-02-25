//
//  EnvironmentValues.swift
//  Digital Signature
//
//  Created by Tran Tien Anh on 25/02/2022.
//
import Foundation
enum EnvironmentValues {
    static let appGroupIdentifier: String = "anh.tt.123.132"

    private(set) static var sharedDefaults: UserDefaults = {
        if let suiteDefaults = UserDefaults(suiteName: appGroupIdentifier) {
            return suiteDefaults
        } else {
            assertionFailure("Unable to find shared app group UserDefaults")
            return .standard
        }
    }()
}
