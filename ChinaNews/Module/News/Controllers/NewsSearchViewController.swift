//
//  NewsSearchViewController.swift
//  ChinaNews
//
//  Created by 汤军 on 2019/7/6.
//  Copyright © 2019 汤军. All rights reserved.
//

import UIKit

class NewsSearchViewController: BaseViewController {

    @IBOutlet weak var searchTextfiled: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "搜索"
    }

    @IBAction func searchClick(_ sender: UIButton) {
        let title = searchTextfiled.text!
        if title.count == 0 { return }
        let newsListViewController = NewsListViewController()
        newsListViewController.requestParameter.title = title
        newsListViewController.title = title
        navigationController?.pushViewController(newsListViewController, animated: true)
    }
}
