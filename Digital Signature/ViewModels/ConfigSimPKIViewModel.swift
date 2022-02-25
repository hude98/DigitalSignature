//
//  ConfigSimPKIViewModel.swift
//  Digital Signature
//
//  Created by Tran Tien Anh on 18/02/2022.
//

import Foundation
import Combine
import Moya

final class ConfigSimPKIViewModel: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    @Published var models: [SimPKIModel] = [] {
        didSet {
            isLoading = false
        }
    }
    @Published var phoneNumber: String?
    @Published var selectedService: ServiceProviderModel?
    @Published var isLoading = true
    let selectionProviderAction: PassthroughSubject<Void, Never> = .init()
    let network: NetworkManager
    func saveConfigSimPKI() {
        guard let selectedService = selectedService, let phoneNumber = phoneNumber else {
            return
        }
        isLoading = true
        
        network
            .getCertificate_SIM_PKI(service: selectedService, phoneNumber: phoneNumber)
            .sink { [weak self ] e in
                self?.isLoading = false
            } receiveValue: { [weak self] model in
                self?.isLoading = false
                guard let cer = model.value.transaction?.certificate else {
                    return
                }
                try? digitalSignConfig.setEncodableValue(.init(value: cer, name: selectedService.name, id: "\(selectedService.id)"), for: \.SimPkiConfig)
            }
            .store(in: &cancellableSet)
    }
    
    
    init(network: NetworkManager) {
        self.network = network
        network
            .getListServiceProvider_SIM_PKI()
            .print("anhtt")
            .replaceError(with: [])
            .assign(to: \.models, on: self)
            .store(in: &cancellableSet)
    }
}



