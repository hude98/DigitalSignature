//
//  SettingViewController.swift
//  Digital Signature
//
//  Created by Tran Tien Anh on 16/02/2022.
//

import UIKit

class SettingViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Setting"
        view.backgroundColor = .white
    }
    

   
}
