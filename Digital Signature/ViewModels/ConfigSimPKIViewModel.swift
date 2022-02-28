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
    @Published var statusMessage: String?
    @Published var certificateInfo: [String]?
    @Published var subject: String?
    let selectionProviderAction: PassthroughSubject<Void, Never> = .init()
    let network: NetworkManager
    func saveConfigSimPKI() {
        guard let selectedService = selectedService, let phoneNumber = phoneNumber else {
            return
        }
        isLoading = true
        network
            .getCertificate_SIM_PKI(service: selectedService, phoneNumber: phoneNumber)
            .handleEvents(receiveOutput: { [weak self] model in
                self?.verifyDigitalCertificate(cerBased64: model.value)
            })
            .sink { [weak self ] e in
                self?.isLoading = false
            } receiveValue: { [weak self] model in
                self?.isLoading = false
                try? digitalSignConfig.setEncodableValue(SimPKIConfigValue(value: model.value, name: selectedService.name, id: "\(selectedService.id)") , for: \.simPkiConfig)
            }
            .store(in: &cancellableSet)
    }
    private func verifyDigitalCertificate(cerBased64: String) {
        self.isLoading = true
       network
            .verifyDigitalCertificate(cerBased64: cerBased64)
            .sink { [weak self] e in
                print(e)
                self?.isLoading = false
            } receiveValue: { [weak self] model in
                self?.isLoading = false
                self?.statusMessage = model.value.statusMessage
                self?.certificateInfo = model.value.certificateInfo
                self?.subject = model.value.subject
                print(model)
            }
            .store(in: &cancellableSet)
    }
    
    init(network: NetworkManager) {
        self.network = network
        network
            .getListServiceProvider_SIM_PKI()
            .replaceError(with: [])
            .assign(to: \.models, on: self)
            .store(in: &cancellableSet)
    }
}



