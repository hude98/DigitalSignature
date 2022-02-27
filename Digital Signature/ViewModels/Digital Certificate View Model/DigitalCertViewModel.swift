//
//  DigitalCertViewModel.swift
//  Digital Signature
//
//  Created by Ta Huy Hung on 27/02/2022.
//

import Foundation
import Combine

class DigitalCertViewModel: ObservableObject {
    let items: [DigitalCertModel]
    @Published var selectedItem: DigitalCertModel?
    init(items: [DigitalCertModel]) {
        self.items = items 
    }
}

