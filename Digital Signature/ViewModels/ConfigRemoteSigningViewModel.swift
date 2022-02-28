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
    @Published var message: String?
    private var deviceInfo = DeviceInfo(
        OS: "ios",
        deviceName: UIDevice.current.name,
        sic_id: "",
        type: "mobile",
        model: UIDevice.current.model,
        version: UIDevice.current.systemVersion,
        serial: UIDevice().identifierForVendor?.uuidString ?? "")
    
    @Published var selectedService: ServiceProviderModel?
    @Published var isLoading = true
    let selectionProviderAction: PassthroughSubject<Void, Never> = .init()
    let network: NetworkManager
    func saveConfigRemoteSigning() {
        guard let selectedService = selectedService, let username = username, let password = password else {
            message = "Điền đầy đủ thông tin"
            return
        }
        isLoading = true
        network
            .getCertificateRemoteSigning(service: selectedService, username: username, password: password, deviceInfo: deviceInfo)
            .handleEvents(receiveOutput: { [weak self] model in
                guard let cert = model.value?.certs.first,
                      let certBase64 = cert.credentialInfo.certificates.first else {
                          self?.message = "Thông tin tài khoản không hợp lệ"
                          return
                      }
                self?.verifyDigitalCertificate(cerBased64: certBase64)
            })
            .sink { [weak self ] e in
                self?.isLoading = false
            } receiveValue: { [weak self] remoteSigningResponseModel in
                self?.isLoading = false
                guard let refreshToken = remoteSigningResponseModel.value?.refreshToken,
                      let cert = remoteSigningResponseModel.value?.certs.first,
                      let certBase64 = cert.credentialInfo.certificates.first
                else {
                    return
                }
                try? digitalSignConfig.setEncodableValue(.init(value: certBase64, name: selectedService.name, id: "\(selectedService.id)", refreshToken: refreshToken, credentialId: cert.credentialID), for: \.remoteSigningConfig)
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
            .getListServiceProviderRemoteSigning()
            .print("anhtt")
            .replaceError(with: [])
            .assign(to: \.models, on: self)
            .store(in: &cancellableSet)
    }
}




