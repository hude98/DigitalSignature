//
//  ViewController.swift
//  Digital Signature
//
//  Created by Tran Tien Anh on 15/02/2022.
//

import UIKit
import SwiftUI
import SnapKit
import MobileCoreServices
import QuickLook

class HomeViewController: UIViewController, UIDocumentPickerDelegate, UIContextMenuInteractionDelegate {
    private let pickerFileView: UIView = .init()
    private let fileNameLB: UILabel = .init()
    private let btnPickFile: UIButton = .init()
    private let iconView: UIImageView = .init()
    private let btnSignFile: UIButton = .init()
    private let btnViewSignFile: UIButton = .init()
    private let actionView: UIView = .init()
    private var currentURl: URL? = nil
    var simKPIViewModel: ConfigSimPKIViewModel!
    var remoteSigningViewModel: ConfigRemoteSigningViewModel!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pickerFileView)
        view.backgroundColor = .white
        pickerFileView.addSubview(fileNameLB)
        pickerFileView.addSubview(iconView)
        pickerFileView.addSubview(btnPickFile)
        view.addSubview(actionView)
        actionView.addSubview(btnSignFile)
        actionView.addSubview(btnViewSignFile)
        pickerFileView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
        }
        
        fileNameLB.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalTo(iconView.snp.leading).offset(-10)
        }
        
        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        btnPickFile.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        actionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(80)
            make.top.equalTo(pickerFileView.snp.bottom).offset(100)
        }
        
        iconView.image = UIImage(named: "search")
        pickerFileView.layer.cornerRadius = 10
        pickerFileView.layer.borderColor = UIColor.black.cgColor
        pickerFileView.layer.borderWidth = 1
        fileNameLB.text = "Chon file"
        fileNameLB.textColor = .black
        btnPickFile.addTarget(self, action: #selector(btnPickerFileDidTap), for: .touchUpInside)
        
        btnSignFile.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalToSuperview().dividedBy(3)
        }
        
        btnViewSignFile.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalToSuperview().dividedBy(3)
        }
        
        btnSignFile.setTitle("Ky file", for: .normal)
        btnSignFile.setTitleColor(.black, for: .normal)
        btnViewSignFile.setTitle("View Chu Ky", for: .normal)
        btnViewSignFile.setTitleColor(.black, for: .normal)
        btnViewSignFile.layer.cornerRadius = 20
        btnSignFile.layer.cornerRadius = 20
        btnViewSignFile.layer.borderWidth = 1
        btnSignFile.layer.borderWidth = 1
        btnSignFile.addTarget(self, action: #selector(btnSignFIleDidTap), for: .touchUpInside)
        
        let settingBtn = UIButton()
        settingBtn.setTitle("setting", for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: settingBtn)
        let settingAction = makeSettingRatingAction()
        let configTSA = makeConfigTSA()
        let configRemote = makeConfigDigitalSignatureRemote()
        
        let rootMenuChildren: [UIMenuElement] = [settingAction, configTSA, configRemote]
        
        let rootMenu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: rootMenuChildren)
        let moreBarButtonItem = UIBarButtonItem(title: nil,
                                                image: .init(named: "three_dots_vertical"),
                                                primaryAction: nil,
                                                menu: rootMenu)
        navigationItem.rightBarButtonItems = [moreBarButtonItem]
    }
    
    @objc
    private func btnPickerFileDidTap() {
        let importMenu = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .fullScreen
        self.present(importMenu, animated: true, completion: nil)
    }
    
    @objc
    private func btnSignFIleDidTap() {
        guard let currentURl = currentURl else {
            showToast(message: "Chọn file trước", font: .systemFont(ofSize: 16))
            return
        }
        let simPKICer =  digitalSignConfig.decodableValue(for: \.simPkiConfig)
        let remoteSign = digitalSignConfig.decodableValue(for: \.remoteSigningConfig)
        let cers:[DigitalCertModel] = [simPKICer, remoteSign].compactMap({$0 as? DigitalCertModel})
        if cers.isEmpty {
            showToast(message: "Cấu hình chứng chỉ trong cài đặt trước", font: .systemFont(ofSize: 16))
            return
        }
        let vc = ConfigSignViewController(viewModel: .init(items: cers))
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
//
//        switch currentURl.pathExtension {
//        case "pdf":
//
//        case "jpeg",
//            "png",
//            "docx",
//            "doc": break
//
//        default:
//            print("default")
//        }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        fileNameLB.text = myURL.lastPathComponent
        currentURl = myURL
        print("import result : \(myURL)")
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        currentURl = nil
        fileNameLB.text = "Chon file"
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let settingAction = makeSettingRatingAction()
        let configTSA = makeConfigTSA()
        let configRemote = makeConfigDigitalSignatureRemote()
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil,
            actionProvider: { _ in
                
                return UIMenu(title: "", children: [settingAction, configTSA, configRemote])
            })
    }
    
    func makeSettingRatingAction() -> UIAction {
        return UIAction(
            title: "Cấu hình ký SimPKI",
            image: nil,
            identifier: nil) { [weak self] _ in
                let settingVC = ConfigSimPKIViewController(networkProvider: .init())
                self?.navigationController?.pushViewController(settingVC, animated: true)
            }
    }
    
    func makeConfigTSA() -> UIAction {
        return UIAction(
            title: "Cấu hình TSA (dấu thời gian)",
            image: nil,
            identifier: nil) { [weak self] _ in
                let settingVC = ConfigTSAViewController(networkProvider: .init())
                self?.navigationController?.pushViewController(settingVC, animated: true)
            }
    }
    
    func makeConfigDigitalSignatureRemote() -> UIAction {
        return UIAction(
            title: "Cấu hình ký số từ xa",
            image: nil,
            identifier: nil) { [weak self] _ in
                let settingVC = ConfigDigitalSignatureRemoteViewController(networkProvider: .init())
                self?.navigationController?.pushViewController(settingVC, animated: true)
            }
    }
}

