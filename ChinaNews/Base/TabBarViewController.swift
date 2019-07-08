//
//  TabBarViewController.swift
//  Swifter
//
//  Created by 汤军 on 2019/4/29.
//  Copyright © 2019 汤军. All rights reserved.
//

import UIKit

extension UIImage {

}

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let v1 = NewsChannelViewController()
        let v2 = NewsCategoryViewController()
        let v3 = NewsSearchViewController()

        v1.tabBarItem = UITabBarItem.init(title: "热门", image: UIImage.init(named: "home"), selectedImage: UIImage.init(named: "home_sel"))
        v2.tabBarItem = UITabBarItem.init(title: "分类", image: UIImage.init(named: "meijiagou"), selectedImage: UIImage.init(named: "meijiagou_sel"))
        v3.tabBarItem = UITabBarItem.init(title: "搜索", image: UIImage.init(named: "wode"), selectedImage: UIImage.init(named: "wode_sel"))

        let n1 = NavigationController.init(rootViewController: v1)
        let n2 = NavigationController.init(rootViewController: v2)
        let n3 = NavigationController.init(rootViewController: v3)

        viewControllers = [n1,n2,n3]
    }
}
