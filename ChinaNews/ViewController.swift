//
//  ViewController.swift
//  ChinaNews
//
//  Created by 汤军 on 2019/7/4.
//  Copyright © 2019 汤军. All rights reserved.
//

import UIKit

class ViewController: BaseTableViewController {

    var newsChannelManager: NewsChannelManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = 44
        registCell(UITableViewCell.self, reuseIdentifier: "UITableViewCell")

        var request = NewsChannelRequest()
        let parameter = NewsSystemParameter().body
        request.parameter = parameter
        ShareNetworkManager.send(request) { [weak self](newsChannelManager, error) in
            self?.newsChannelManager = newsChannelManager
            self?.tableView.reloadData()
        }
    }

    override func numberOfRowsInSection(_ section: Int) -> Int {
        return newsChannelManager?.channels.count ?? 0
    }

    override func cellForRowAt(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") else {
            return UITableViewCell()
        }
        let channel = newsChannelManager!.channels[indexPath.row]
        cell.textLabel?.text = channel.name
        cell.detailTextLabel?.text = channel.channelId
        return cell
    }

    
}

