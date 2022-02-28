//
//  ConfigSignViewController.swift
//  Digital Signature
//
//  Created by Tran Tien Anh on 28/02/2022.
//

import Foundation
import UIKit
import SwiftUI
import Combine


class ConfigSignViewController: UIViewController {
    let viewModel: ConfigSignViewModel
    private lazy var contentViewController: UIHostingController<ContentView> = .init(rootView: ContentView(viewModel: viewModel)
    )
    private var cancellabletSet: Set<AnyCancellable> = []
    
    init(viewModel: ConfigSignViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        contentViewController.willMove(toParent: self)
        addChild(contentViewController)
        view.addSubview(contentViewController.view)
        view.backgroundColor = .black.withAlphaComponent(0.8)
        contentViewController.didMove(toParent: self)
        contentViewController.view.backgroundColor = .white
        contentViewController.view.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().offset(40)
        }
        viewModel
            .selectionCerAction
            .sink( receiveValue: { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                let vc = DigitalCertSelectionViewController(viewModel: .init(items: strongSelf.viewModel.items))
                vc.delegate = self
                strongSelf.present(vc, animated: true)
            })
            .store(in: &cancellabletSet)
    }
    
    @objc private func viewDidTap(_ sender: UITapGestureRecognizer) {
        let location =  sender.location(in: contentViewController.view)
        if location.x > 0, location.x < contentViewController.view.bounds.width, location.y > 0 , location.y < contentViewController.view.bounds.height {
            return
        }
        dismiss(animated: true, completion: nil)
    }
}


extension ConfigSignViewController {
    struct ContentView: View {
        @ObservedObject var viewModel: ConfigSignViewModel
        
        var body: some View {
            VStack(spacing: 0) {
                Text("Chọn chứng thư số")
                    .bold()
                    .padding(.vertical)
                    .frame(minWidth: 300)
                
                Button {
                    viewModel.selectionCerAction.send()
                } label: {
                    SelectionView(selected: Binding(get: {
                        viewModel.selectedCer?.name
                    }, set: { _ in
                        
                    }), title: "Chọn nhà cung cấp")
                }
                .padding(.horizontal)
                
                Toggle(isOn: $viewModel.isConfigTSA, label: {
                    Text("TSA")
                })
                .padding(.all, 16)
                
                ButtonView(icon: .init(systemName: "Back"), title: "Ky", widthBtn: 125) {
                    print("Ky")
                }
            }
            .frame(alignment: .center)
        }
    }
}




extension ConfigSignViewController: DigitalCertViewControllerDelegate {
    func selectDigitalCertViewController(_ controller: DigitalCertSelectionViewController, didSelected item: DigitalCertModel) {
        viewModel.selectedCer = item
    }
}
