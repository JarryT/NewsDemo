//
//  BaseViewController.swift
//  Swifter
//
//  Created by 汤军 on 2019/4/29.
//  Copyright © 2019 汤军. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()

        view.backgroundColor = UIColor.white
    }

    func setUpNavigationBar() {
//        configCustomerNavigationBar()
    }
}

//extension BaseViewController: UINavigationBarHelper {}
