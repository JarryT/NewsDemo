//
//  News.swift
//  ChinaNews
//
//  Created by 汤军 on 2019/7/4.
//  Copyright © 2019 汤军. All rights reserved.
//

import UIKit

/// define request
struct NewsListRequest: NetworkRequest {
    var path: String = "http://route.showapi.com/109-35"
    var method: NetworkMethod = .GET
    var parameter: [String : String] = NewsSystemParameter().body
    typealias Response = NewsItemListManager
}

struct NewsChannelRequest: NetworkRequest {
    var path: String = "http://route.showapi.com/109-34"
    var method: NetworkMethod = .GET
    var parameter: [String : String] = NewsSystemParameter().body
    typealias Response = NewsChannelManager
}

/// define data manager
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
        allNum = json["allNum"].intValue
        allPages = json["allPages"].intValue
        currentPage = json["currentPage"].intValue
        maxResult = json["maxResult"].intValue
        for news in json["contentlist"].arrayValue {
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
        return NewsItemListManager.init(json: data["pagebean"])
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
    var havePic: Bool = false
    var images: [NewsImage] = [NewsImage]()
    init(json: JSON) {
        title = json["title"].stringValue
        content = json["content"].stringValue
        link = json["link"].stringValue
        pubDate = json["pubDate"].stringValue
        source = json["source"].stringValue
        description = json["desc"].stringValue
        channelId = json["channelId"].stringValue
        channelName = json["channelName"].stringValue
        nid = json["nid"].stringValue
        havePic = (json["havePic"].intValue > 0)
        print("havePic -- \(havePic)")
        images.removeAll()
        for image in json["imageurls"].arrayValue {
            let imageJson = JSON.init(image)
            images.append(NewsImage.init(json: imageJson))
        }
    }
}

/// define data 
struct NewsChannel {
    var id: String = ""
    var name: String = ""
    init(json: JSON) {
        id = json["channelId"].stringValue
        name = json["name"].stringValue
    }
}

struct NewsImage {
    var url: String = ""
    var height: Float = 0
    var wight: Float = 0
    init(json: JSON) {
        url = json["url"].stringValue
        height = json["height"].floatValue
        wight = json["wight"].floatValue
    }
}


