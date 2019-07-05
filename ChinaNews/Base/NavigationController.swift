//
//  NavigationController.swift
//  Swifter
//
//  Created by 汤军 on 2019/4/29.
//  Copyright © 2019 汤军. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = viewControllers.count == 1
        super.pushViewController(viewController, animated: true)
    }
}
