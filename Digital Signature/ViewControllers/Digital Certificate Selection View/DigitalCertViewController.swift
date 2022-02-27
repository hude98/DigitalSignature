//
//  DigitalCertViewController.swift
//  Digital Signature
//
//  Created by Ta Huy Hung on 27/02/2022.
//

import Foundation
import UIKit
import SwiftUI
import Combine

protocol DigitalCertViewControllerDelegate: AnyObject {
    func selectDigitalCertViewController(_ controller: DigitalCertSelectionViewController, didSelected item: DigitalCertModel)
}

class DigitalCertSelectionViewController: UIViewController {
    let viewModel: DigitalCertViewModel
    weak var delegate: DigitalCertViewControllerDelegate?
    private lazy var contentViewController: UIHostingController<ContentView> = .init(rootView: ContentView(viewModel: viewModel)
    )
    private var cancellabletSet: Set<AnyCancellable> = []
    
    init(viewModel: DigitalCertViewModel) {
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
            .$selectedItem
            .compactMap({$0})
            .sink { [weak self] model in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.delegate?.selectDigitalCertViewController(strongSelf, didSelected: model)
                strongSelf.dismiss(animated: true, completion: nil)
            }
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


extension DigitalCertSelectionViewController {
    struct ContentView: View {
        @ObservedObject var viewModel: DigitalCertViewModel
        
        var body: some View {
            VStack(spacing: 0) {
                Text("Chọn chứng thư số")
                    .bold()
                    .padding(.vertical)
                    .frame(minWidth: 300)
                Spacer()
                Text("Chọn")
                    .onTapGesture {
                        //showpopup
                    }
            }
            .frame(alignment: .center)
        }
    }
}


//struct DigitalCertView: View {
//    var listName: [String]
//    var body: some View {
//        VStack(spacing: 0) {
//            Text("Chọn chứng thư số")
//                .bold()
//                .padding(.vertical)
//                .frame(minWidth: 300)
//            Spacer()
//            ForEach(0 ..< listName.count) { name in
//                Text(name)
//            }
//            .padding(.horizontal, 5)
//        }
//        .frame(alignment: .center)
//    }
//}


