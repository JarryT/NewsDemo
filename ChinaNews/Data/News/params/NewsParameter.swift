//
//  NewsParameter.swift
//  ChinaNews
//
//  Created by 汤军 on 2019/7/4.
//  Copyright © 2019 汤军. All rights reserved.
//

import UIKit

func CurrentNewTimestamp() -> String {
    let timeFomatter = DateFormatter()
    timeFomatter.dateFormat = "yyyyMMddHHmmss"
    let date = Date()
    return timeFomatter.string(from: date)
}

func sortedParamers(_ body: [String: String]) -> String{
    return ""
}

struct NewsSystemParameter {
    var body: [String: String] {
        get {
            let stamp = CurrentNewTimestamp()
            return ["showapi_appid":"99316", "showapi_timestamp":stamp, "showapi_res_gzip":"0"]
        }
    }
}

struct NewsListParameter {
    var channelId: String = ""
    var channelName: String = ""
    var title: String = ""
    var page: String = "1"
    var needContent: String = "1"
    var needHtml: String = "0"
    var needAllList: String = "0"
    var maxResult: String = "20"
    var body: [String: String] {
        get {
            return ["channelId":channelId,"channelName":channelName,"title":title,"page":page,"needContent":needContent,"needHtml":needHtml,"needAllList":needAllList,"maxResult":maxResult]
        }
    }
}
