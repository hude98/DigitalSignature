//
//  ConfigSimPKIViewController.swift
//  Digital Signature
//
//  Created by Tran Tien Anh on 17/02/2022.
//

import UIKit
import SwiftUI
import Combine
import JGProgressHUD

class ConfigSimPKIViewController: UIViewController {
    private lazy var contentViewController: UIHostingController<ContentView> = .init(rootView: ContentView(viewModel: viewModel))
    var viewModel: ConfigSimPKIViewModel!
    private var cancellabletSet: Set<AnyCancellable> = []
    init(networkProvider: NetworkManager) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = ConfigSimPKIViewModel(network: networkProvider)
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
        title = "Cấu hình ký SimPKI"
        contentViewController.willMove(toParent: self)
        addChild(contentViewController)
        view.addSubview(contentViewController.view)
        contentViewController.view.backgroundColor = .white
        contentViewController.didMove(toParent: self)
        let hud = JGProgressHUD()
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 3.0)
        viewModel
            .$isLoading
            .sink { [weak self] isLoading in
                guard let strongSelf = self else {
                    return
                }
                if isLoading {
                    hud.show(in: strongSelf.view)
                } else {
                    hud.dismiss()
                }
            }
            .store(in: &cancellabletSet)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        contentViewController.view.frame = view.bounds
    }
}


extension ConfigSimPKIViewController: SelectionProviderViewControllerDelegate {
    func selectionProviderViewController(_ controller: SelectionProviderViewController, didSelected item: ServiceProviderModel) {
        viewModel.selectedService = item
    }
}

extension ConfigSimPKIViewController {
    struct ContentView: View {
        @ObservedObject var viewModel: ConfigSimPKIViewModel
        var body: some View {
            VStack(spacing: 0) {
                Text("Vui lòng nhập đầy đủ thông tin cấu hình")
                    .font(.body.bold())
                Button {
                    viewModel.selectionProviderAction.send()
                } label: {
                    SelectionView(selected: Binding(get: {
                        viewModel.selectedService?.name
                    }, set: { _ in
                        
                    }), title: "Chọn nhà cung cấp")
                }
                
                .padding(.all, 16)
                
                InputView(content: $viewModel.phoneNumber ?? "", title: "Số điện thoại", keyboardType: .phonePad)
                    .padding(.all, 16)
                ScrollView {
                    CertificateInfoView(contents: $viewModel.certificateInfo ?? [], statusMessage: $viewModel.statusMessage ?? "")
                }
                .padding(.horizontal)
                GeometryReader { geometry in
                    HStack(alignment: .center, spacing: 0) {
                        Spacer()
                        ButtonView(icon: .init(systemName: "Back"), title: "thoát", widthBtn: 125) {
                            print("thoat")
                        }
                        Spacer()
                        ButtonView(icon: .init(systemName: "Back"), title: "Lưu", widthBtn: 125) {
                            viewModel.saveConfigSimPKI()
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


//struct CertificateInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        CertificateInfoView(contents: [
//            "Chủ sở hữu: HUNG SIM 2",
//            "Đơn vị cấp phát: Newtel Certification Authority",
//            "Thời gian hiệu lực: 1/14/2022 đến 1/14/2023"
//        ], statusMessage: "Tình trạng: Chứng chỉ Root CA không hợp lệ")
//    }
//}
