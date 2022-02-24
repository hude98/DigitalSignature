//
//  CAAPI.swift
//  Digital Signature
//
//  Created by Tran Tien Anh on 18/02/2022.
//

import Foundation
import Moya
enum CAAPI {
    case getListServiceProviderTSA
    case getCertificate(service: ServiceProviderModel, phoneNumber: String)
    case getListServiceProvider_SIM_PKI
    case getCertificateRemoteSigning(service: ServiceProviderModel, username: String, password: String, deviceInfo: DeviceInfo)
    case getListServiceProvider_REMOTE_SIGNING
    case verifySignatureDoc(type: String, data: Data)
    case verifyDigitalCertificate(certificateBase64: String)
}
extension CAAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "http://caapi.yoctovn.com/ca/") else {
            fatalError("baseURL could not be configured.")
        }
        return url
    }
    
    var path: String {
        switch self {
            
        case .getListServiceProviderTSA:
            return "GetListServiceProviderTSA"
        case .getCertificate:
            return "GetCertificate"
        case .getListServiceProvider_SIM_PKI:
            return "GetListServiceProvider/SIM_PKI"
        case .getCertificateRemoteSigning:
            return "GetCertificateRemoteSigning"
        case .getListServiceProvider_REMOTE_SIGNING:
            return "GetListServiceProvider/REMOTE_SIGNING"
        case .verifySignatureDoc(_,_):
            return "VerifySignatureDoc"
        case .verifyDigitalCertificate:
            return "VerifyDigitalCertificate"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getListServiceProviderTSA,
                .getListServiceProvider_SIM_PKI,
                .getListServiceProvider_REMOTE_SIGNING:
            return .get
            
        case .getCertificate,
                .verifyDigitalCertificate,
            .getCertificateRemoteSigning,
            .verifySignatureDoc:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
            
        case .getListServiceProviderTSA:
            return .requestPlain
        case .getCertificate(let service, let phoneNumber):
            return .requestJSONEncodable(GetCertificateRequestModel(ProviderId: "\(service.id)", Mobile: phoneNumber))
        case .getListServiceProvider_SIM_PKI:
            return .requestPlain
            
        case .getCertificateRemoteSigning(let service, let userName, let password, let deviceInfo):
//            return .requestParameters(parameters: ["ProviderId": service.id,
//                                                   "Username": userName,
//                                                   "Password": password,
//                                                   "DeviceInfo": deviceInfo
//                                                  ], encoding: URLEncoding.httpBody)
            
            return .requestJSONEncodable(GetCertificateRemoteSigningModel(
                ProviderId: "\(service.id)",
                Username: userName,
                Password: password,
                DeviceInfo: deviceInfo))
        case .getListServiceProvider_REMOTE_SIGNING:
            return .requestPlain
        case .verifySignatureDoc(_,_):
            return .requestPlain
            
        case .verifyDigitalCertificate(let certificateBase64):
            return .requestJSONEncodable(VerifyDigitalCertificate(CertificateBase64: certificateBase64))
        }
    }
    
    var headers: [String : String]? {
        var header = ["Content-type": "application/json",
                      "Connection": "keep-alive",
                      "Accept":  "*/*",
                      "Accept-Encoding": "gzip, deflate, br"
              ]
        return header
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    
}

private struct GetCertificateRequestModel: Codable {
    let ProviderId: String
    let Mobile: String
}

private struct VerifyDigitalCertificate: Codable {
    let CertificateBase64: String
}

private struct GetCertificateRemoteSigningModel: Codable{
    let ProviderId: String
    let Username: String
    let Password: String
    let DeviceInfo: DeviceInfo
}
