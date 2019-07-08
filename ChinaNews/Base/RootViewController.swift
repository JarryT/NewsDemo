//
//  RootViewController.swift
//  Swifter
//
//  Created by 汤军 on 2019/5/27.
//  Copyright © 2019 汤军. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    var containerController: TabBarViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerController = TabBarViewController()
        if let container = containerController {
            addChild(container)
            view.addSubview(container.view)
        }
    }
}
