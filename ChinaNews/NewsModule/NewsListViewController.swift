//
//  NewsListViewController.swift
//  ChinaNews
//
//  Created by 汤军 on 2019/7/5.
//  Copyright © 2019 汤军. All rights reserved.
//

import UIKit

class NewsListViewController: BaseTableViewController {

    var channel: NewsChannel? {
        didSet {
            if let channel = channel {
                requestParameter.channelName = channel.name
                requestParameter.channelId = channel.id
            }
        }
    }
    var request = NewsListRequest()
    var requestParameter = NewsListParameter()
    var newsListManager: NewsItemListManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refreshRequestState()

        tableView.estimatedRowHeight = 66
        tableView.rowHeight = UITableView.automaticDimension
        registCell(NewsListCell.self, reuseIdentifier: NewsListCell.Identifiter)
        
        ShareNetworkManager.send(request) { [weak self](newsListManager, error) in
            self?.newsListManager = newsListManager
            self?.tableView.reloadData()
        }
    }

    ///whenever change parameter, need to update the request.parameter
    func refreshRequestState() {
        request.addParameter(requestParameter.body)
    }

    override func numberOfRowsInSection(_ section: Int) -> Int {
        return newsListManager?.contentlist.count ?? 0
    }

    override func cellForRowAt(_ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsListCell.Identifiter) as! NewsListCell
        let item = newsListManager!.contentlist[indexPath.row]
        cell.newsItem = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
