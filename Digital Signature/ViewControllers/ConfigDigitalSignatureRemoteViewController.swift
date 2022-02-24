//
//  ConfigDigitalSignatureRemoteViewController.swift
//  Digital Signature
//
//  Created by Tran Tien Anh on 17/02/2022.
//

import UIKit
import SwiftUI
class ConfigDigitalSignatureRemoteViewController: UIViewController {
    private lazy var contentViewController: UIHostingController<ContentView> = .init(rootView: ContentView())

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

extension ConfigDigitalSignatureRemoteViewController {
    struct ContentView: View {
        @State var userName: String = ""
        @State var userPass: String = ""
        var body: some View {
            VStack(spacing: 0) {
                Text("Vui lòng nhập đầy đủ thông tin cấu hình")
                    .font(.body.bold())
                Button {
                    
                } label: {
                    SelectionView(content: nil, title: "Chọn nhà cung cấp")
                }
                .padding(.all, 16)
                
                InputView(content: $userName, title: "Tài khoản", keyboardType: .default)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                InputView(content: $userPass, title: "Mật khẩu", keyboardType: .default)
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
        ConfigDigitalSignatureRemoteViewController.ContentView()
    }
}
