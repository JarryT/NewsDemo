//
//  WebViewController.swift
//  JiaMeiC Swift
//
//  Created by 汤军 on 2018/10/12.
//  Copyright © 2018年 汤军. All rights reserved.
//

import UIKit

class WebViewController: BaseViewController {

    var urlString: String = ""{
        didSet{
            webView.loadRequest(with: urlString)
        }
    }
    
    var htmlName: String = ""{
        didSet{
            webView.loadHTML(with: htmlName)
        }
    }
    
    private lazy var webView = WebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        webView.frame = self.view.bounds
        self.view.addSubview(webView)
    }
}
