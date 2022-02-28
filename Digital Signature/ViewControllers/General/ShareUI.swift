//
//  UIViewController.swift
//  Digital Signature
//
//  Created by Ta Huy Hung on 26/02/2022.
//

import Foundation
import UIKit
import SwiftUI

struct SelectionView: View {
    @Binding var model: ServiceProviderModel?
    var title: String
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(model?.name ?? title)
                    .bold()
                    .foregroundColor(model == nil ? nil : .red)
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


struct DigitalCertSelectionView: View {
    //    @Binding var model: SigningModel?
    @State private var isUsingTSAConfig = false
    var body: some View {
        VStack {
            Spacer()
            Text("Chọn")
                .foregroundColor(.gray)
            Spacer()
            Text("TSA")
                .foregroundColor(.gray)
            Spacer()
            Toggle("Show welcome message", isOn: $isUsingTSAConfig)
            if isUsingTSAConfig {
                
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
    var isSecure = false
    
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
                if isSecure {
                    SecureField("", text: $content)
                        .keyboardType(keyboardType)
                } else {
                    TextField("", text: $content)
                        .keyboardType(keyboardType)
                }
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


struct CertificateInfoView: View {
    @Binding var contents: [String]
    @Binding var statusMessage: String
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(contents,id: \.self) { message in
                Text(message)
                    .foregroundColor(.gray)
                
            }
            Text(statusMessage)
                .bold()
                .foregroundColor(.red)
        }
    }
}


extension UIViewController {
    
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = "  " +  message +  "  "
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        toastLabel.sizeToFit()
        
        self.view.addSubview(toastLabel)
        toastLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.view.snp.bottom).offset(-60)
            
        }
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
