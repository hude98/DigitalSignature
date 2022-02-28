//
//  ConfigSignViewModel.swift
//  Digital Signature
//
//  Created by Tran Tien Anh on 28/02/2022.
//

import Foundation
import SwiftUI
import Combine

final class ConfigSignViewModel: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    @Published var isConfigTSA = false
    @Published var selectedCer: DigitalCertModel?
    let selectionCerAction: PassthroughSubject<Void, Never> = .init()

    var items: [DigitalCertModel]
    init (items: [DigitalCertModel]) {
        self.items = items
    }
}
