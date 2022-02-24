//
//  ConfigTSAViewController.swift
//  Digital Signature
//
//  Created by Tran Tien Anh on 17/02/2022.
//

import UIKit

import UIKit
import SwiftUI

class ConfigTSAViewController: UIViewController {
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

extension ConfigTSAViewController {
    struct ContentView: View {
        var body: some View {
            VStack(spacing: 0) {
                Text("Vui lòng nhập đầy đủ thông tin cấu hình")
                    .font(.body.bold())
                Button {
                    
                } label: {
                    SelectionView(content: "nil", title: "Chọn nhà cung cấp")
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


struct ContentView_ConfigTSAViewController_Previews: PreviewProvider {
    static var previews: some View {
        ConfigTSAViewController.ContentView()
    }
}

