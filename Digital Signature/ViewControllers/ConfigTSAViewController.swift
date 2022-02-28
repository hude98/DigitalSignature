//
//  ConfigTSAViewController.swift
//  Digital Signature
//
//  Created by Tran Tien Anh on 17/02/2022.
//

import UIKit
import SwiftUI
import Combine
import JGProgressHUD


class ConfigTSAViewController: UIViewController {
    private lazy var contentViewController: UIHostingController<ContentView> = .init(rootView: ContentView(viewModel: viewModel))
    var viewModel: ConfigTSAViewModel!
    private var cancellabletSet: Set<AnyCancellable> = []
    init(networkProvider: NetworkManager) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = ConfigTSAViewModel(network: networkProvider)
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

        title = "Cấu hình TSA (dấu thời gian)"
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

extension ConfigTSAViewController: SelectionProviderViewControllerDelegate {
    func selectionProviderViewController(_ controller: SelectionProviderViewController, didSelected item: ServiceProviderModel) {
        viewModel.selectedService = item
    }
}

extension ConfigTSAViewController {
    struct ContentView: View {
        @ObservedObject var viewModel: ConfigTSAViewModel
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
                            viewModel.saveConfigTSA()
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


//struct ContentView_ConfigTSAViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        CertificateInfoView(contents: [
//            "Thành công"
//        ], statusMessage: "Thành công")
//    }
//}

