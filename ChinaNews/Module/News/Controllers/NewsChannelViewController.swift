//
//  NewsChannelViewController.swift
//  ChinaNews
//
//  Created by 汤军 on 2019/7/5.
//  Copyright © 2019 汤军. All rights reserved.
//

import UIKit

class NewsChannelViewController: BaseTableViewController {

    var newsChannelManager: NewsChannelManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        navigationItem.title = "China News"

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = 44
        registCell(UITableViewCell.self, reuseIdentifier: "UITableViewCell")
        let request = NewsChannelRequest()
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
        cell.selectionStyle = .none
        let channel = newsChannelManager!.channels[indexPath.row]
        cell.textLabel?.text = channel.name
        cell.detailTextLabel?.text = channel.id
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsListViewController = NewsListViewController()
        newsListViewController.channel = newsChannelManager?.channels[indexPath.row]
        navigationController?.pushViewController(newsListViewController, animated: true)
    }
}
