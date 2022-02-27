//
//  SelectionProviderViewModel.swift
//  Digital Signature
//
//  Created by Tran Tien Anh on 19/02/2022.
//

import Foundation
import Combine

class SelectionProviderViewModel: ObservableObject {
    let items: [ServiceProviderModel]
    @Published var selectedItem: ServiceProviderModel?
    init(items: [ServiceProviderModel]) {
        self.items = items
    }
}
