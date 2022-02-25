//
//  SelectionProviderViewController.swift
//  Digital Signature
//
//  Created by Tran Tien Anh on 19/02/2022.
//

import Foundation
import UIKit
import SwiftUI
import Combine

protocol SelectionProviderViewControllerDelegate: AnyObject {
    func selectionProviderViewController(_ controller: SelectionProviderViewController, didSelected item: ServiceProviderModel)
}

class SelectionProviderViewController: UIViewController {
    let viewModel: SelectionProviderViewModel
    weak var delegate: SelectionProviderViewControllerDelegate?
    private lazy var contentViewController: UIHostingController<ContentView> = .init(rootView: ContentView(viewModel: viewModel)
    )
    private var cancellabletSet: Set<AnyCancellable> = []

    init(viewModel: SelectionProviderViewModel) {
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
                strongSelf.delegate?.selectionProviderViewController(strongSelf, didSelected: model)
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

extension SelectionProviderViewController {
    struct ContentView: View {
        @ObservedObject var viewModel: SelectionProviderViewModel
        
        var body: some View {
            VStack(spacing: 0) {
                Text("Vui lòng chọn nhà cung cấp")
                    .bold()
                    .padding(.vertical)
                    .frame(minWidth: 300)
                ScrollView {
                    ForEach(viewModel.items, id: \.id) { model in
                        ProviderView(model: model)
                            .onTapGesture {
                                viewModel.selectedItem = model
                            }
                    }
                    .padding(.horizontal, 5)
                }
                .frame(maxHeight: 400)
            }
            .frame(alignment: .center)
        }
        
    }
}
struct ProviderView: View {
    let model: ServiceProviderModel
    init(model: ServiceProviderModel) {
        self.model = model
    }
    var body: some View {
        VStack {
            HStack {
                Text("\(model.id)")
                    .padding(.leading)
                Spacer()
                Text(model.name.uppercased())
                    .bold()
                    .foregroundColor(.red)
                Spacer()
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 5)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 2)
            )
        }
        .padding(.bottom, 5)
    }
}

