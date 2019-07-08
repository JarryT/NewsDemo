//
//  NewsCategoryViewController.swift
//  ChinaNews
//
//  Created by 汤军 on 2019/7/6.
//  Copyright © 2019 汤军. All rights reserved.
//

import UIKit

class NewsCategoryViewController: BaseTableViewController {

    lazy var datasource: [NewsGroup] = {
        return createDatarouce()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = 44
        registCell(UITableViewCell.self, reuseIdentifier: "UITableViewCell")

        navigationItem.title = "分类"
    }

    override func numberOfSections() -> Int {
        return datasource.count
    }

    override func numberOfRowsInSection(_ section: Int) -> Int {
        let group = datasource[section]
        return group.contents.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let group = datasource[section]
        return group.title
    }

    override func cellForRowAt(_ indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell") else {
            return UITableViewCell()
        }
        let group = datasource[indexPath.section]
        let content = group.contents[indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.text = content.title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsListViewController = NewsListViewController()
        let group = datasource[indexPath.section]
        let content = group.contents[indexPath.row]
        newsListViewController.requestParameter.title = content.title
        newsListViewController.title = content.title
        navigationController?.pushViewController(newsListViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}



extension NewsCategoryViewController {

    //define the data
    struct NewsGroup {
        var contents: [NewsContent] = [NewsContent]()
        var title: String = ""
        init(json: JSON) {
            title = json["title"].stringValue
            for contentJson in json["content"].arrayValue {
                contents.append(NewsContent.init(json: contentJson))
            }
        }
    }

    struct NewsContent {
        var title: String = ""
        init(json: JSON) {
            title = json["title"].stringValue
        }
    }

    func createDatarouce() -> [NewsGroup] {
        let dataArray = [
            ["title":"体育", "content":[["title":"中超"],["title":"中超"],["title":"英超"]]],
            ["title":"娱乐", "content":[["title":"明星"],["title":"电影"],["title":"星座"]]],
            ["title":"汽车", "content":[["title":"报价"],["title":"买车"],["title":"新车"]]]
        ]
        let jsonArray = dataArray.map({ (dict) -> JSON in return JSON.init(dict) })
        var temp = [NewsGroup]()
        for json in jsonArray {
            temp.append(NewsGroup.init(json: json))
        }
        return temp
    }
}
