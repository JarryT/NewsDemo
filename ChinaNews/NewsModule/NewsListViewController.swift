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

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = 44
        registCell(UITableViewCell.self, reuseIdentifier: "UITableViewCell")
        
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") else {
            return UITableViewCell()
        }
        let item = newsListManager!.contentlist[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.source
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
