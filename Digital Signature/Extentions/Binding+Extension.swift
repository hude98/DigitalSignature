//
//  Binding+Extension.swift
//  Digital Signature
//
//  Created by Tran Tien Anh on 19/02/2022.
//

import SwiftUI
import Foundation

func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
