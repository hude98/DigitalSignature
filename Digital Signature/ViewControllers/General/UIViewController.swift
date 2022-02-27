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
    @FocusState var isInputActive: Bool
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
                
                //                HungDzTextField(text: $content, keyType: keyboardType)
                //                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 20)
                
                TextField("", text: $content)
                    .keyboardType(keyboardType)
                    .focused($isInputActive)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                isInputActive = false
                            }
                        }
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
