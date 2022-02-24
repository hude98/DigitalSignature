//
//  ConfigSimPKIViewController.swift
//  Digital Signature
//
//  Created by Tran Tien Anh on 17/02/2022.
//

import UIKit
import SwiftUI

class ConfigSimPKIViewController: UIViewController {
    private lazy var contentViewController: UIHostingController<ContentView> = .init(rootView: ContentView())

    init() {
        super.init(nibName: nil, bundle: nil)
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
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        contentViewController.view.frame = view.bounds
    }

}

extension ConfigSimPKIViewController {
    struct ContentView: View {
        @State var phoneNumber: String = ""
        var body: some View {
            VStack(spacing: 0) {
                Text("Vui lòng nhập đầy đủ thông tin cấu hình")
                    .font(.body.bold())
                Button {
                    
                } label: {
                    SelectionView(content: nil, title: "Chọn nhà cung cấp")
                }
                
                .padding(.all, 16)
                
                InputView(content: $phoneNumber, title: "Số điện thoại", keyboardType: .phonePad)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigSimPKIViewController.ContentView()
    }
}

struct SelectionView: View {
    @State var content: String?
    var title: String
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(content ?? title)
                    .bold()
                    .foregroundColor(content?.isEmpty ?? true ? nil : .red)
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(Color.gray)
        .opacity(0.5)
        .cornerRadius(5)
    }
}

struct InputView: View {
    @Binding var content: String
    var title: String
    let keyboardType: UIKeyboardType

    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                if content.isEmpty {
                    HStack {
                        Spacer()
                        Text(title)
                            .bold()
                        Spacer()
                    }
                }
                TextField("", text: $content)
                    .keyboardType(keyboardType)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(Color.gray)
        .opacity(0.5)
        .cornerRadius(5)
    }
}


struct ButtonView: View {
    var padingHorizontal: CGFloat = 16
    var paddingVertical: CGFloat = 16
    var cornerRadius: CGFloat = 10
    var widthBtn: CGFloat?
    let icon: Image
    let title: String
    let action: () -> ()
    init(icon: Image,
         title: String,
         widthBtn: CGFloat? = nil,
         cornerRadius: CGFloat = 10,
         paddingVertical: CGFloat = 16,
         padingHorizontal: CGFloat = 16,
         action: @escaping () -> () = {}
    ) {
        self.paddingVertical = paddingVertical
        self.padingHorizontal = padingHorizontal
        self.action = action
        self.title = title
        self.widthBtn = widthBtn
        self.cornerRadius = cornerRadius
        self.icon = icon
    }
    var body: some View {
        Button {
            action()
        } label: {
            HStack(alignment: .center) {
                icon
                    .frame(width: 20, height: 20)
                Text(title.uppercased())
                    .foregroundColor(.white)
            }
            
            .padding(.horizontal, padingHorizontal)
            .padding(.vertical, paddingVertical)
            .frame(width: widthBtn)
            .background(Color.blue)
            .cornerRadius(cornerRadius)
        }

     
    }
    
    
}
