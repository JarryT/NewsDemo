//
//  News.swift
//  ChinaNews
//
//  Created by 汤军 on 2019/7/4.
//  Copyright © 2019 汤军. All rights reserved.
//

import UIKit

struct NewsChannelManager: NetworkParsable {
    var totalNum: Int = 0
    var channels: [NewsChannel] = [NewsChannel]()
    init(json: JSON) {
        totalNum = json["totalNum"].intValue
        let channelList = json["channelList"]
        channels.removeAll()
        for channel in channelList.arrayValue {
            channels.append(NewsChannel.init(json: channel))
        }
    }
    static func parse(data: JSON) -> NewsChannelManager? {
        return NewsChannelManager.init(json: data)
    }
}

struct NewsItemListManager: NetworkParsable {
    var allNum: NSInteger = 0
    var allPages: NSInteger = 0
    var currentPage: NSInteger = 0
    var maxResult: NSInteger = 0
    var contentlist: [NewsItem] = [NewsItem]()

    init(json: JSON) {
        allNum = json["allNum"].int ?? 0
        allPages = json["allPages"].int ?? 0
        currentPage = json["allPages"].int ?? 0
        maxResult = json["allPages"].int ?? 0
        for news in json["contentlist"] {
            let newsJson = JSON.init(news)
            contentlist.append(NewsItem.init(json: newsJson))
        }
    }

    mutating func appendNewsItem(from newsItemListManager: NewsItemListManager ) {
        allNum = newsItemListManager.allNum
        allPages = newsItemListManager.allPages
        currentPage = newsItemListManager.currentPage
        maxResult = newsItemListManager.maxResult
        if newsItemListManager.currentPage == 0 {
            self.contentlist = newsItemListManager.contentlist
        } else {
            self.contentlist.append(contentsOf: newsItemListManager.contentlist)
        }
    }

    static func parse(data: JSON) -> NewsItemListManager? {
        return NewsItemListManager.init(json: data)
    }
}

struct NewsItem {
    var title: String = ""
    var content: String = ""
    var link: String = ""
    var pubDate: String = ""
    var source: String = ""
    var description: String = ""
    var channelId: String = ""
    var channelName: String = ""
    var nid: String = ""
    var images: [NewsImage] = [NewsImage]()

    init(json: JSON) {
        title = json["title"].string ?? ""
        content = json["content"].string ?? ""
        link = json["link"].string ?? ""
        pubDate = json["pubDate"].string ?? ""
        source = json["source"].string ?? ""
        description = json["desc"].string ?? ""
        channelId = json["channelId"].string ?? ""
        channelName = json["channelName"].string ?? ""
        nid = json["nid"].string ?? ""

        images.removeAll()
        for image in json["imageurls"] {
            let imageJson = JSON.init(image)
            images.append(NewsImage.init(json: imageJson))
        }
    }
}

struct NewsChannel {
    var channelId: String = ""
    var name: String = ""
    init(json: JSON) {
        channelId = json["channelId"].string ?? ""
        name = json["name"].string ?? ""
    }
}

struct NewsImage {
    var url: String = ""
    var height: Float = 0
    var wight: Float = 0
    init(json: JSON) {
        url = json["url"].string ?? ""
        height = json["height"].float ?? 0
        wight = json["wight"].float ?? 0
    }
}


