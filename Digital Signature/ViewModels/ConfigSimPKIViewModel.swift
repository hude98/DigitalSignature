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
            .sink { [weak self ] e in
                self?.isLoading = false
            } receiveValue: { [weak self] model in
                self?.isLoading = false
                self?.statusMessage = model.value.statusMessage
                self?.certificateInfo = model.value.certificateInfo
                self?.subject = model.value.subject
                print(model)
                guard let cer = model.value.transaction?.certificate else {
                    return
                }
                print("cer: \(cer)")
                self?.saveDigitalCertInfo(self?.statusMessage, self?.certificateInfo, DigitalConfigName.SimPKI, String(selectedService.id), cer)
//                try? digitalSignConfig.setEncodableValue(.init(value: cer, name: selectedService.name, id: "\(selectedService.id)"), for: \.simPkiConfig)
            }
            .store(in: &cancellableSet)
    }
    
    private func saveDigitalCertInfo(_ statusMessage: String?, _ certificateInfo: [String]?,_ signType: String?, _ providerId: String?, _ cerBase64: String?){
        let digitalCertInfo = SigningConfig(statusMessage: statusMessage,
                                            certificateInfo: certificateInfo,
                                            signType: signType,
                                            providerId: providerId,
                                            cerBase64: cerBase64)
        do{
            let encoder = JSONEncoder()
            let data = try encoder.encode(digitalCertInfo)
            UserDefaults.standard.set(data, forKey: DigitalConfigName.SimPKI)
        }
        catch{
            print("Unable to encode digitalCertInfo (\(error))")
        }
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



