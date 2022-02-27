//
//  NetworkManager.swift
//  Digital Signature
//
//  Created by Tran Tien Anh on 18/02/2022.
//

import Foundation
import Moya
import CombineMoya
import Combine
protocol Networkable {
    associatedtype T: TargetType
    var provider: MoyaProvider<T> { get }
}
struct NetworkManager: Networkable {
    typealias T = CAAPI
    let provider = MoyaProvider<CAAPI>(plugins: [NetworkLoggerPlugin()])
    
    func signDocument(service: ServiceSigning) -> AnyPublisher<VerifyDigitalCertificateModel, MoyaError> {
        return provider
            .requestPublisher(.getSignDocument(service: service))
            .map(CertificateModel.self)
            .flatMap({ model -> AnyPublisher<VerifyDigitalCertificateModel, MoyaError>  in
                return self.verifyDigitalCertificate(cerBased64: model.value)
            })
            .eraseToAnyPublisher()
    }
    
    func getListServiceProvider_SIM_PKI() -> AnyPublisher<[SimPKIModel], MoyaError>{
        return provider
            .requestPublisher(.getListServiceProvider_SIM_PKI)
            .map(ServiceProviderSimPKI.self)
            .map({$0.data})
            .eraseToAnyPublisher()
    }
    
    func getCertificate_SIM_PKI(service: ServiceProviderModel, phoneNumber: String) -> AnyPublisher<VerifyDigitalCertificateModel, MoyaError>  {
        return provider
            .requestPublisher(.getCertificate(service: service, phoneNumber: phoneNumber))
            .map(CertificateModel.self)
            .flatMap({ model -> AnyPublisher<VerifyDigitalCertificateModel, MoyaError>  in
                return self.verifyDigitalCertificate(cerBased64: model.value)
            })
            .eraseToAnyPublisher()
    }
    
    func verifyDigitalCertificate(cerBased64: String) -> AnyPublisher<VerifyDigitalCertificateModel, MoyaError> {
        return provider
            .requestPublisher(.verifyDigitalCertificate(certificateBase64: cerBased64))
            .map(VerifyDigitalCertificateModel.self)
            .eraseToAnyPublisher()
    }

    
    func getListServiceProviderRemoteSigning() -> AnyPublisher<[RemoteSigningModel], MoyaError>{
        return provider
            .requestPublisher(.getListServiceProvider_REMOTE_SIGNING)
            .map(ServiceProviderRemoteSigning.self)
            .map({$0.data})
            .eraseToAnyPublisher()
    }
    
    func getCertificateRemoteSigning(service: ServiceProviderModel, username: String, password: String, deviceInfo: DeviceInfo) -> AnyPublisher<VerifyDigitalCertificateModel, MoyaError> {
        return provider
            .requestPublisher(.getCertificateRemoteSigning(service: service, username: username, password: password, deviceInfo: deviceInfo))
            .map(CertificateModel.self)
            .flatMap({ model -> AnyPublisher<VerifyDigitalCertificateModel, MoyaError>  in
                return self.verifyDigitalCertificate(cerBased64: model.value)
            })
            .eraseToAnyPublisher()
    }
    
    func getListServiceProviderTSA() -> AnyPublisher<[TSAModel], MoyaError>{
        return provider
            .requestPublisher(.getListServiceProviderTSA)
            .map(ServiceProviderTSA.self)
            .map({$0.data})
            .eraseToAnyPublisher()
    }
    
}
