//
//  ConfigSigningViewModel.swift
//  Digital Signature
//
//  Created by Ta Huy Hung on 24/02/2022.
//


import Foundation
import Combine
import Moya
import UIKit
import SwiftUI

final class ConfigSigningViewModel: ObservableObject {
    private var cancellableSet = Set<AnyCancellable>()
    @Published var models: [RemoteSigningModel] = [] {
        didSet {
            isLoading = false
        }
    }
    @Published var username: String?
    @Published var password: String?
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





