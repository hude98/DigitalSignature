//
//  ConfigTSAViewModel.swift
//  Digital Signature
//
//  Created by Ta Huy Hung on 23/02/2022.
//

import Foundation
import Combine
import Moya

final class ConfigTSAViewModel: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    @Published var models: [TSAModel] = [] {
        didSet {
            isLoading = false
        }
    }
    @Published var selectedService: ServiceProviderModel?
    @Published var isLoading = true
    let selectionProviderAction: PassthroughSubject<Void, Never> = .init()
    let network: NetworkManager
    
    func saveConfigTSA() {
        isLoading = true
        
        network
            .getListServiceProviderTSA()
            .sink { [weak self ] e in
                self?.isLoading = false
            } receiveValue: { [weak self] model in
                self?.isLoading = false
                print(model)
            }
            .store(in: &cancellableSet)
    }
    
    init(network: NetworkManager) {
        self.network = network
        network
            .getListServiceProviderTSA()
            .print("anhtt")
            .replaceError(with: [])
            .assign(to: \.models, on: self)
            .store(in: &cancellableSet)
    }
}



