//
//  ConfigRemoteSigningViewModel.swift
//  Digital Signature
//
//  Created by Ta Huy Hung on 23/02/2022.
//


import Foundation
import Combine
import Moya
import UIKit
import SwiftUI

final class ConfigRemoteSigningViewModel: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    @Published var models: [RemoteSigningModel] = [] {
        didSet {
            isLoading = false
        }
    }
    @Published var username: String?
    @Published var password: String?
    @Published var statusMessage: String?
    @Published var certificateInfo: [String]?
    @Published var subject: String?
    private var deviceInfo = DeviceInfo(
        OS: "ios",
        deviceName: UIDevice.current.name,
        sic_id: "",
        type: "mobile",
        model: UIDevice.current.model,
        version: UIDevice.current.systemVersion,
        serial: "")
    
    @Published var selectedService: ServiceProviderModel?
    @Published var isLoading = true
    let selectionProviderAction: PassthroughSubject<Void, Never> = .init()
    let network: NetworkManager
    func saveConfigRemoteSigning() {
        guard let selectedService = selectedService, let username = username, let password = password else {
            return
        }
        isLoading = true
        
        network
            .getCertificateRemoteSigning(service: selectedService, username: username, password: password, deviceInfo: deviceInfo) 
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
                self?.saveDigitalCertInfo(self?.statusMessage, self?.certificateInfo, DigitalConfigName.RemoteSigning, String(selectedService.id), cer)
//                try? digitalSignConfig.setEncodableValue(.init(value: cer, name: selectedService.name, id: "\(selectedService.id)"), for: \.remoteSigningConfig)
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
            UserDefaults.standard.set(data, forKey: DigitalConfigName.RemoteSigning)
        }
        catch{
            print("Unable to encode digitalCertInfo (\(error))")
        }
    }
    
    init(network: NetworkManager) {
        self.network = network
        network
            .getListServiceProviderRemoteSigning()
            .print("anhtt")
            .replaceError(with: [])
            .assign(to: \.models, on: self)
            .store(in: &cancellableSet)
    }
}




