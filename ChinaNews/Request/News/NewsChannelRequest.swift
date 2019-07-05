//
//  NewsChannelRequest.swift
//  ChinaNews
//
//  Created by 汤军 on 2019/7/4.
//  Copyright © 2019 汤军. All rights reserved.
//

import UIKit

struct NewsChannelRequest: NetworkRequest {
    var path: String = "http://route.showapi.com/109-34"
    var method: NetworkMethod = .GET
    var parameter: [String : String] = [String : String]()
    typealias Response = NewsChannelManager
}
