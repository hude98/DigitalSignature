//
//  ConfigDigitalSignatureRemoteViewController.swift
//  Digital Signature
//
//  Created by Tran Tien Anh on 17/02/2022.
//

import UIKit
import SwiftUI
import Combine
import JGProgressHUD

class ConfigDigitalSignatureRemoteViewController: UIViewController {
    private lazy var contentViewController: UIHostingController<ContentView> = .init(rootView: ContentView(viewModel: viewModel))
    var viewModel: ConfigRemoteSigningViewModel!
    private var cancellabletSet: Set<AnyCancellable> = []
    init(networkProvider: NetworkManager) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = ConfigRemoteSigningViewModel(network: networkProvider)
        Publishers
            .CombineLatest(viewModel.selectionProviderAction, viewModel.$models)
            .map({$1})
            .sink { [weak self] models in
                self?.openSelectionProviders(models: models)
            }
            .store(in: &cancellabletSet)
    }
    
    private func openSelectionProviders(models: [ServiceProviderModel]) {
        let vc = SelectionProviderViewController(viewModel: .init(items: models))
        vc.delegate = self
        vc.modalTransitionStyle   = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.view.tintColor = .clear
        self.present(vc, animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Cấu hình ký số từ xa"
        contentViewController.willMove(toParent: self)
        addChild(contentViewController)
        view.addSubview(contentViewController.view)
        contentViewController.view.backgroundColor = .white
        contentViewController.didMove(toParent: self)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        contentViewController.view.frame = view.bounds
    }

}

extension ConfigDigitalSignatureRemoteViewController: SelectionProviderViewControllerDelegate {
    func selectionProviderViewController(_ controller: SelectionProviderViewController, didSelected item: ServiceProviderModel) {
        viewModel.selectedService = item
    }
}

extension ConfigDigitalSignatureRemoteViewController {
    struct ContentView: View {
        @ObservedObject var viewModel: ConfigRemoteSigningViewModel
        @State var userName: String = ""
        @State var userPass: String = ""
        
        var body: some View {
            VStack(spacing: 0) {
                Text("Vui lòng nhập đầy đủ thông tin cấu hình")
                    .font(.body.bold())
                Button {
                    viewModel.selectionProviderAction.send()
                } label: {
                    SelectionView(model: $viewModel.selectedService, title: "Chọn nhà cung cấp")
                }
                .padding(.all, 16)
                
                InputView(content: $viewModel.username ?? "", title: "Tài khoản", keyboardType: .default)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                InputView(content: $viewModel.password ?? "", title: "Mật khẩu", keyboardType: .default)
                    .padding(.horizontal, 16)
                
                Spacer()
                    .frame(alignment: .center)
                GeometryReader { geometry in
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        ButtonView(icon: .init(systemName: "Back"), title: "thoát", widthBtn: 125) {
                            print("thoat")
                        }
                        Spacer()
                        ButtonView(icon: .init(systemName: "Back"), title: "Lưu", widthBtn: 125) {
                            viewModel.saveConfigRemoteSigning()
                            print("Lưu")
                        }
                        Spacer()
                    }
                }
                Spacer()
            }
            .padding()
            .frame(alignment: .center)
        }
    }
}


struct ContentView_ConfigDigital_Previews: PreviewProvider {
    static var previews: some View {
        CertificateInfoView(contents: [
            "Chủ sở hữu: ThanhTuVtc",
            "Đơn vị cấp phát: Internal Root CA",
            "Thời gian hiệu lực: 1/13/2022 đến 1/13/2023"
        ], statusMessage: "Tình trạng: Chứng chỉ Root CA không hợp lệ")
    }
}
